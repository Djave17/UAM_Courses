//
//  ModelTests.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 4/2/25.
//

import XCTest
@testable import AppGestionUAM

final class ModelTests: XCTestCase {
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    // MARK: - 1. Validar Inicialización
    
    /// Caso de prueba para la inicialización con valores por defecto.
    func testInitializationWithDefaultValues() {
        // Dado (Given)
        let defaultCourse = CourseModel()
        
        // Cuando (When) -> no hay acciones específicas
        // Entonces (Then) verificamos que las propiedades sean las esperadas:
        XCTAssertEqual(defaultCourse.id, "")
        XCTAssertEqual(defaultCourse.name, "")
        XCTAssertEqual(defaultCourse.description, "")
        XCTAssertEqual(defaultCourse.learningObjectives, "")
        XCTAssertEqual(defaultCourse.schedule, "")
        XCTAssertEqual(defaultCourse.prerequisites, "")
        XCTAssertTrue(defaultCourse.materials.isEmpty)
        XCTAssertEqual(defaultCourse.imageUrl, "")
        XCTAssertNil(defaultCourse.isFavorite)
    }
    
    /// Caso de prueba para la inicialización con valores personalizados.
    func testInitializationWithCustomValues() {
        // Dado (Given)
        let course = CourseModel(
            id: "123",
            name: "Programación en Swift",
            description: "Curso avanzado de Swift para iOS",
            learningObjectives: "Aprender Swift 5.0 y patrones de diseño",
            schedule: "Lunes y Miércoles, 18:00-20:00",
            prerequisites: "Bases de programación",
            materials: ["Libro Swift", "Proyectos Xcode"],
            imageUrl: "https://example.com/swift.png"
        )
        
        // Cuando (When) -> no hay acciones específicas
        // Entonces (Then)
        XCTAssertEqual(course.id, "123")
        XCTAssertEqual(course.name, "Programación en Swift")
        XCTAssertEqual(course.description, "Curso avanzado de Swift para iOS")
        XCTAssertEqual(course.learningObjectives, "Aprender Swift 5.0 y patrones de diseño")
        XCTAssertEqual(course.schedule, "Lunes y Miércoles, 18:00-20:00")
        XCTAssertEqual(course.prerequisites, "Bases de programación")
        XCTAssertEqual(course.materials, ["Libro Swift", "Proyectos Xcode"])
        XCTAssertEqual(course.imageUrl, "https://example.com/swift.png")
        XCTAssertNil(course.isFavorite)
    }
    
    // MARK: - 2. Prueba de Codificación y Decodificación (Codable)
    func testCourseEncodingAndDecoding() throws {
        let originalCourse = CourseModel(
            id: "C002",
            name: "Programación Swift",
            description: "Aprende conceptos básicos de Swift",
            learningObjectives: "Manejar clases, structs y protocolos",
            schedule: "Martes 10:00 - 12:00",
            prerequisites: "Conocimientos básicos de programación",
            materials: ["Mac", "Xcode"],
            imageUrl: "http://example.com/swift.png"
        )
        
        // Codificar
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalCourse)
        
        // Decodificar
        let decoder = JSONDecoder()
        let decodedCourse = try decoder.decode(CourseModel.self, from: encodedData)
        
        XCTAssertEqual(decodedCourse.id, originalCourse.id)
        XCTAssertEqual(decodedCourse.name, originalCourse.name)
        XCTAssertEqual(decodedCourse.description, originalCourse.description)
        XCTAssertEqual(decodedCourse.learningObjectives, originalCourse.learningObjectives)
        XCTAssertEqual(decodedCourse.schedule, originalCourse.schedule)
        XCTAssertEqual(decodedCourse.prerequisites, originalCourse.prerequisites)
        XCTAssertEqual(decodedCourse.materials, originalCourse.materials)
        XCTAssertEqual(decodedCourse.imageUrl, originalCourse.imageUrl)
        XCTAssertNil(decodedCourse.isFavorite, "isFavorite debe mantenerse nil si no se asigna en la codificación")
    }
    
    // MARK: - 3. Asegurar la integridad (Hashable y comparación)
    
    /// Caso de prueba para verificar que dos instancias con los mismos datos son iguales (Hashable).
    func testCourseModelHashable() {
        // Dado
        let course1 = CourseModel(id: "001", name: "Test")
        let course2 = CourseModel(id: "001", name: "Test")
        
        // Cuando & Entonces
        XCTAssertEqual(course1, course2, "Dos CourseModel con los mismos datos deben ser iguales")
        XCTAssertEqual(course1.hashValue, course2.hashValue, "Hash de CourseModel debería coincidir para datos iguales")
    }
    
}
