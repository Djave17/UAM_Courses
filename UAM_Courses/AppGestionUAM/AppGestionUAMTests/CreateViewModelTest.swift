//
//  CreateViewModelTest.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 4/2/25.
//

import XCTest
@testable import AppGestionUAM

final class CreateViewModelTest: XCTestCase {
    
    var viewModel: CreateCourseViewModel!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        
        Task {
            await MainActor.run {
                viewModel = CreateCourseViewModel()
            }
        }
    }
    
    
    override func tearDown() {
        viewModel = nil
        mockAPIClient = nil
        super.tearDown()
    }
    
    // MARK: - 1. Validar Campos Requeridos
    func testValidateFields_EmptyFields_ShouldReturnFalse() async {
        await MainActor.run {
            viewModel.name = ""
            viewModel.description = ""
            viewModel.learningObjectives = ""
            viewModel.schedule = ""
            viewModel.prerequisites = ""
            viewModel.materials = []
        }
        
        let result = await MainActor.run { viewModel.validateFields() }
        XCTAssertFalse(result, "Debe fallar si los campos están vacíos")
    }
    
    func testValidateFields_FilledFields_ShouldReturnTrue() async {
        await MainActor.run {
            viewModel.name = "Curso de iOS"
            viewModel.description = "Aprende desarrollo en Swift"
            viewModel.learningObjectives = "Dominar MVVM"
            viewModel.schedule = "Lunes y miércoles"
            viewModel.prerequisites = "Conocimientos básicos de programación"
            viewModel.materials = ["Libro de Swift", "Xcode"]
        }
        
        let result = await MainActor.run { viewModel.validateFields() }
        XCTAssertTrue(result, "Debe pasar si los campos están llenos")
    }
    
    
    // MARK: - 2. Simulación de Creación de Curso (Mock API)
    func testCreateCourse_Success() async {
        await MainActor.run {
            viewModel.name = "Curso de SwiftUI"
            viewModel.description = "Aprende SwiftUI desde cero"
            viewModel.learningObjectives = "Crear apps con SwiftUI"
            viewModel.schedule = "Martes y jueves"
            viewModel.prerequisites = "Swift básico"
            viewModel.materials = ["Xcode", "Mac"]
        }
        
        let expectation = XCTestExpectation(description: "Curso creado exitosamente")
        
        await MainActor.run {
            viewModel.onSuccess = {
                expectation.fulfill()
            }
        }
        
        await MainActor.run { viewModel.createCourse() }
        await fulfillment(of: [expectation], timeout: 3.0)
    }

    func testCreateCourse_Failure_MissingFields() async {
        await MainActor.run {
            viewModel.name = "Curso de Prueba"
            viewModel.description = ""
            viewModel.learningObjectives = ""
            viewModel.schedule = "Viernes"
            viewModel.prerequisites = "Ninguno"
            viewModel.materials = []
        }
        
        let expectation = XCTestExpectation(description: "Falla por campos incompletos")
        
        await MainActor.run {
            viewModel.onError = { errorMessage in
                XCTAssertEqual(errorMessage, "Todos los campos son obligatorios.")
                expectation.fulfill()
            }
        }
        
        await MainActor.run { viewModel.createCourse() }
        
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    func testCreateCourse_Failure_ApiError() async {
        
        await MainActor.run {
            viewModel.name = "Curso con error"
            viewModel.description = "Prueba de error"
            viewModel.learningObjectives = "Testeo"
            viewModel.schedule = "Sábados"
            viewModel.prerequisites = "Ninguno"
            viewModel.materials = ["Swift Guide"]
            viewModel.selectedImage = UIImage() // Simular una imagen
        }
        mockAPIClient.shouldFail = true
        
        let expectation = XCTestExpectation(description: "Falla por error de API")
        
        await MainActor.run {
            viewModel.onError = { errorMessage in
                XCTAssertEqual(errorMessage, "Error al crear el curso.")
                expectation.fulfill()
            }
        }
        
        await MainActor.run { viewModel.createCourse() }

        await fulfillment(of: [expectation], timeout: 3.0)
    }
}

// MARK: - Mock APIClient para simular respuestas de API
final class MockAPIClient: APIClient {
    var shouldFail = false
    
    override func createCourse(course: CourseModel) async -> CourseModel? {
        if shouldFail {
            return nil
        }
        return course
    }
    
    override func uploadImage(image: UIImage) async throws -> String {
        if shouldFail {
            throw APIError.serverError("Error al subir imagen.")
        }
        return "http://example.com/image.png"
    }
    
    
    
}
