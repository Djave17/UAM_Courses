//
//  DetailsViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 14/1/25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //Referencia de Componentes
    
    @IBOutlet weak var btnContactanos: UIButton!
    
    
    @IBOutlet weak var views: UIView!
    
    
    //Modelo de los cursos
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var btnMarkFavorite: UIButton!
    @IBOutlet weak var descripcionTextView: UITextView!
    @IBOutlet weak var lblNameCourse: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var txtRequierements: UITextView!
    @IBOutlet weak var objetivesTextView: UITextView!
    @IBOutlet weak var recursosButton: UIButton! //materiales
    @IBOutlet weak var materialesTextField: UITextView!
    
    var viewModel: CourseDetailViewModel?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let name = name else { return }
        setButtons()
        viewModel = CourseDetailViewModel()
        loadCourseDetails(name: name)
    }
    
    private func loadCourseDetails(name: String) {
        guard let viewModel = viewModel else { return }
        
        Task {
            await viewModel.fetchCourseDetails(name: name)
            guard let course = viewModel.course else {
                print("Course not found")
                return
            }
            
            DispatchQueue.main.async {
                print("Updating UI with course details")
                self.lblNameCourse.text = course.name
                self.descripcionTextView.text = course.description
                self.objetivesTextView.text = course.learningObjectives
                self.scheduleLabel.text = course.schedule
                self.txtRequierements.text = course.prerequisites
                self.materialesTextField.text = course.materials.joined(separator: ", ")
                
                Task {
                    print("Loading course image from URL: \(course.imageUrl)")
                    if let image = await self.viewModel?.loadImage(for: course.imageUrl) {
                        DispatchQueue.main.async {
                            self.courseImage.image = image
                        }
                    } else {
                        print("Failed to load course image")
                    }
                }
            }
        }
        
        
    }
    func setButtons() {
        // Configuración de los botones y vistas
        recursosButton.clipsToBounds = true
        recursosButton.layer.cornerRadius = 12
        
        // Configuración de los textViews
        descripcionTextView.isEditable = false
        descripcionTextView.isScrollEnabled = true
        txtRequierements.isEditable = false
        txtRequierements.isScrollEnabled = true
        materialesTextField.isEditable = false
        materialesTextField.isScrollEnabled = true
        
        // Personalización del título del curso
        lblNameCourse.numberOfLines = 3
        lblNameCourse.textAlignment = .center
        
        courseImage.clipsToBounds = true
        courseImage.layer.cornerRadius = 20
        
    }
    
}
    
