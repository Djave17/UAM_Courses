//
//  CourseListUITest.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 4/2/25.
//


import XCTest

final class CourseListUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        
        // Simular una sesión activa en UserDefaults
        let defaults = UserDefaults.standard
        defaults.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiRWxpYXMgU2FuY2hleiAiLCJlbWFpbCI6ImVsaXNhbmNoZXpAdWFtdi5lZHUubmkiLCJleHAiOjE3NDEyMTc5MTN9.e0f_lEg_6LuwflC-yDHhG_LieCO1VbuX7GpUF9QH6F4", forKey: "token")
        defaults.set("elisanchez@uamv.edu.ni", forKey: "userEmail")
        defaults.set("67a1536d55a31465848e9acc", forKey: "id") // ID del usuario simulado
        
        app.launch()
        
    }
    
    override func tearDownWithError() throws {
        // **Limpiar datos después de cada prueba**
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "token")
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "id")
    }
    
    func testVerificarListaDeCursos() throws {
        // Verificar que la pantalla de cursos se cargue correctamente
        let courseList = app.collectionViews.firstMatch
        XCTAssertTrue(courseList.waitForExistence(timeout: 5), "La pantalla de cursos no se cargó")
    }
    
    // MARK: - 1. Validar que la lista de cursos se carga
    func testCoursesLoadSuccessfully() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10), "La lista de cursos no se ha cargado correctamente")
        XCTAssertGreaterThan(collectionView.cells.count, 0, "No hay cursos disponibles en la lista")
    }

    // MARK: - 2. Buscar un curso por nombre
    func testSearchCourse() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists, "El campo de búsqueda no está presente")

        searchField.tap()
        searchField.typeText("Swift")
        app.keyboards.buttons["Search"].tap()

        let collectionView = app.collectionViews.firstMatch
        XCTAssertGreaterThan(collectionView.cells.count, 0, "No se encontraron cursos con el término de búsqueda")
    }

    // MARK: - 3. Navegar a detalle de curso
    func testNavigateToCourseDetail_LongPress() {
        let firstCourse = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCourse.waitForExistence(timeout: 10), "No hay cursos en la lista")

        firstCourse.press(forDuration: 1.0)

        let detailTitle = app.staticTexts["Estructuras de datos"] // Nombre del primer curso
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 5), "No se navegó a la pantalla de detalles con long press")
    }

    // MARK: - 4. Agregar curso a favoritos
    func testAddCourseToFavorites() {
        let firstCourse = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCourse.waitForExistence(timeout: 10), "No hay cursos en la lista")

        let favoriteButton = firstCourse.buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 10), "El botón de favoritos no está disponible")

        favoriteButton.tap()

        let favoriteTab = app.buttons["favoritesTab"]
        favoriteTab.tap()

        let favoriteCourse = app.collectionViews.cells.firstMatch
        XCTAssertTrue(favoriteCourse.exists, "El curso no se agregó a favoritos")
    }

    // MARK: - 5. Navegar a la pantalla de favoritos
    func testNavigateToFavorites() {
        let favoriteButton = app.buttons["favoritesButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "El botón de favoritos no está en la interfaz")

        favoriteButton.tap()
        
        let favoriteTitle = app.staticTexts["Cursos Favoritos"]
        XCTAssertTrue(favoriteTitle.waitForExistence(timeout: 5), "No se navegó a la pantalla de favoritos")
    }

    // MARK: - 6. Navegar a la pantalla de perfil
    func testNavigateToProfile() {
        let profileButton = app.buttons["profileTab"]
        XCTAssertTrue(profileButton.exists, "El botón de perfil no está en la interfaz")

        profileButton.tap()

        let profileTitle = app.staticTexts["Perfil"]
        XCTAssertTrue(profileTitle.waitForExistence(timeout: 5), "No se navegó a la pantalla de perfil")
    }

    // MARK: - 7. Agregar un curso y verificarlo en la lista
    func testAddNewCourse() {
        let addButton = app.buttons["addCourseButton"]
        XCTAssertTrue(addButton.exists, "El botón de agregar curso no está presente")

        addButton.tap()

        let courseNameField = app.textFields["Nombre del curso"]
        XCTAssertTrue(courseNameField.waitForExistence(timeout: 5), "No se abrió la pantalla de creación de curso")

        courseNameField.tap()
        courseNameField.typeText("Curso de iOS Avanzado")

        let saveButton = app.buttons["Guardar Curso"]
        saveButton.tap()

        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5), "La lista de cursos no se cargó")

        let newCourse = collectionView.cells.staticTexts["Curso de iOS Avanzado"]
        XCTAssertTrue(newCourse.exists, "El curso no se agregó a la lista")
    }
}

