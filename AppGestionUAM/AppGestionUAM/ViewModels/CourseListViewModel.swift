//
//  CourseListViewModel.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

class CourseListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var favorites: [Course] = []
    
    func fetchCourses() {
        APIClient.shared.fetchCourses { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let courses):
                    self.courses = courses
                case .failure(let error):
                    print("Error fetching courses: \(error)")
                }
            }
        }
    }
    
    func toggleFavorite(courseID: String) {
        // Busca el índice del curso en el array
        if let index = courses.firstIndex(where: { $0.id == courseID }) {
            
            var updatedCourse = courses[index]
            updatedCourse.isFavorite.toggle()
            
            // Guarda o elimina de favoritos según el nuevo estado
            if updatedCourse.isFavorite {
                FavoritesManager().saveFavorite(course: updatedCourse)
            } else {
                FavoritesManager().removeFavorite(courseID: updatedCourse.id)
            }
            
            // Reemplaza el curso en el array con el curso modificado
            courses[index] = updatedCourse
        }
    }
}

//
//eres un experto. Revisa
//Datos no cargados:
//El método fetchCourses() depende de APIClient.shared.fetchCourses. Si este método no devuelve datos o encuentra un error, la lista de cursos permanecerá vacía.
//No hay datos "dummy" o predeterminados en el caso de que falle la carga.
//
//Si es necesario hacerlo con outles y con cells en XIB aqui tienes el archivo
//Solución: Verifica que APIClient.shared.fetchCourses devuelva correctamente un Result con cursos válidos.
//Ejemplo de prueba: En el fetchCourses() del ViewModel, prueba inicializar con datos predeterminados antes de conectar el cliente API.
//func fetchCourses() {
//    self.courses = [
//        Course(id: "1", name: "Curso de Swift", schedule: "Lunes y Miércoles", imageUrl: "", isFavorite: false),
//        Course(id: "2", name: "Curso de Diseño UI", schedule: "Martes y Jueves", imageUrl: "", isFavorite: true)
//    ]
//}
//Falta de Constraints o tamaño del CollectionView:
//setupCollectionView() en `CourseList
