////
////  CourseListViewModel.swift
////  AppGestionUAM
////
////  Created by David Sanchez on 14/11/24.
////
//
//import Foundation
//
//class CourseListViewModel: ObservableObject {
//    @Published var courses: [CourseModel] = []
//    @Published var errorMessage: String?
//    
//    private let courseListController = CourseListController()
//    
//    func fetchCourses(query: String = "") {
//        // Initialize with dummy data for local testing
//        self.courses = [
//            CourseModel(id: "1", name: "Curso de Swift", description: "Aprende Swift", learningObjectives: "Dominar Swift", schedule: "Lunes y Miércoles", prerequisites: "Ninguno", materials: [], imageUrl: "", isFavorite: false),
//            CourseModel(id: "2", name: "Curso de UI/UX", description: "Diseño moderno", learningObjectives: "Dominar UI", schedule: "Martes y Jueves", prerequisites: "Conocimientos básicos", materials: [], imageUrl: "", isFavorite: true)
//        ]
//        
//        // Fetch from API
//        Task {
//            do {
//                if let fetchedCourses = await courseListController.fetchCourses(query: query) {
//                    DispatchQueue.main.async {
//                        self.courses = fetchedCourses
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "No se pudieron cargar los cursos. Inténtalo de nuevo más tarde."
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error al obtener los cursos: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//}
//








//import Foundation
//
//class CourseListViewModel: ObservableObject {
//
//    @Published var courses: [CourseModel] = []
//    @Published var favorites: [CourseModel] = []
//
//    func fetchCourses() {
//        // Inicialización con datos predeterminados
//        self.courses = [
//            CourseModel(id: "1", name: "Curso de Swift", description: "Aprende Swift", learningObjectives: "Dominar Swift", schedule: "Lunes y Miércoles", prerequisites: "Ninguno", materials: [], imageUrl: "", isFavorite: false),
//            CourseModel(id: "2", name: "Curso de Diseño UI", description: "Diseña interfaces", learningObjectives: "Dominar UI/UX", schedule: "Martes y Jueves", prerequisites: "Conocimientos básicos", materials: [], imageUrl: "", isFavorite: true)
//        ]
//
//        // Llamada al cliente API
//        Task {
//            let result = await APIClient.shared.fetchCourses()
//            DispatchQueue.main.async {
//                if let courses = result {
//                    self.courses = courses
//                } else {
//                    print("Error fetching courses or no data available.")
//                }
//            }
//        }
//    }
//
//    func toggleFavorite(courseID: String) {
//        // Busca el índice del curso en el array
//        if let index = courses.firstIndex(where: { $0.id == courseID }) {
//
//            var updatedCourse = courses[index]
//            updatedCourse.isFavorite.toggle()
//
//            // Guarda o elimina de favoritos según el nuevo estado
//            if updatedCourse.isFavorite {
//                FavoritesManager().saveFavorite(course: updatedCourse)
//            } else {
//                FavoritesManager().removeFavorite(courseID: updatedCourse.id)
//            }
//
//            // Reemplaza el curso en el array con el curso modificado
//            courses[index] = updatedCourse
//        }
//    }
//}

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
