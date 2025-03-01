//
//  Untitled.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 4/2/25.
//

import XCTest
@testable import AppGestionUAM

final class PersistenceTest: XCTestCase {
    var favoritesManager: FavoritesManager!
    let testUserId = "test_user_123"
    let testCourseId = "course_ABC"
    
    override func setUp() {
        super.setUp()
        favoritesManager = FavoritesManager()
        clearUserDefaults() // Limpia antes de cada test
    }
    override func tearDown() {
        clearUserDefaults() // Limpia después de cada test
        super.tearDown()
    }
    
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
    // MARK: - 1. Agregar Favoritos
    func testAddFavoriteCourse() {
        favoritesManager.saveFavorite(courseID: testCourseId, userId: testUserId)
        
        let favorites = favoritesManager.fetchFavoriteIDs(userId: testUserId)
        
        XCTAssertTrue(favorites.contains(testCourseId), "El curso debe estar en favoritos")
    }
    
    // MARK: - 2. Eliminar Favoritos
    func testRemoveFavoriteCourse() {
        favoritesManager.saveFavorite(courseID: testCourseId, userId: testUserId)
        favoritesManager.removeFavorite(courseID: testCourseId, userId: testUserId)
        
        let favorites = favoritesManager.fetchFavoriteIDs(userId: testUserId)
        
        XCTAssertFalse(favorites.contains(testCourseId), "El curso NO debe estar en favoritos después de eliminarlo")
    }
    
    // MARK: - 3. Validar Persistencia en UserDefaults
    func testFavoritesPersistence() {
        favoritesManager.saveFavorite(courseID: "course_XYZ", userId: testUserId)
        
        // Crear una nueva instancia (simulando reinicio de la app)
        let newManagerInstance = FavoritesManager()
        let favorites = newManagerInstance.fetchFavoriteIDs(userId: testUserId)
        
        XCTAssertTrue(favorites.contains("course_XYZ"), "Los favoritos deben persistir en UserDefaults")
    }
    
    // MARK: - 4. No duplicar favoritos
    func testPreventDuplicateFavorites() {
        favoritesManager.saveFavorite(courseID: testCourseId, userId: testUserId)
        favoritesManager.saveFavorite(courseID: testCourseId, userId: testUserId) // Intentar agregarlo otra vez
        
        let favorites = favoritesManager.fetchFavoriteIDs(userId: testUserId)
        
        XCTAssertEqual(favorites.count, 1, "El curso solo debe aparecer una vez en favoritos")
    }
    
    // MARK: - 5. Obtener Favoritos vacíos cuando no hay datos
    func testFetchFavoritesWhenEmpty() {
        let favorites = favoritesManager.fetchFavoriteIDs(userId: testUserId)
        
        XCTAssertTrue(favorites.isEmpty, "Debe devolver un array vacío si el usuario no tiene favoritos")
    }
    
    // MARK: - 6. Validar múltiples usuarios
    func testDifferentUsersHaveSeparateFavorites() {
        let user1 = "user_1"
        let user2 = "user_2"
        
        favoritesManager.saveFavorite(courseID: "course_A", userId: user1)
        favoritesManager.saveFavorite(courseID: "course_B", userId: user2)
        
        let favoritesUser1 = favoritesManager.fetchFavoriteIDs(userId: user1)
        let favoritesUser2 = favoritesManager.fetchFavoriteIDs(userId: user2)
        
        XCTAssertTrue(favoritesUser1.contains("course_A"), "User 1 debe tener course_A como favorito")
        XCTAssertFalse(favoritesUser1.contains("course_B"), "User 1 NO debe tener course_B")
        
        XCTAssertTrue(favoritesUser2.contains("course_B"), "User 2 debe tener course_B como favorito")
        XCTAssertFalse(favoritesUser2.contains("course_A"), "User 2 NO debe tener course_A")
    }
    
    // MARK: - 7. Borrar datos de UserDefaults antes/después de cada test
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "favoriteCoursesIDs_\(testUserId)")
    }
    
    
    
    
    
    
    
    
}
