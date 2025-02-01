//
//  DetailsViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 14/1/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    //Referencia de Componentes
    //MARK: - OUTLETs
    @IBOutlet weak var views: UIView!
    //Modelo de los cursos
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var btnMarkFavorite: UIButton!
    @IBOutlet weak var descripcionTextView: UITextView!
    
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var courseNameTextView: UITextView!
    @IBOutlet weak var scheduleTextView: UITextView!
    @IBOutlet weak var txtRequierements: UITextView!
    @IBOutlet weak var objetivesTextView: UITextView!
    @IBOutlet weak var recursosButton: UIButton! //materiales
    @IBOutlet weak var materialesTextField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - Activity indicator (Carga)
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //MARK: - Modelos
    var viewModel: CourseDetailViewModel!
    var name: String?
    var courseID: String?
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let name = name else { return }
       
        print("DetailViewController cargado, courseID: \(courseID ?? "nil")")
        setButtons()
        viewModel = CourseDetailViewModel()
        loadCourseDetails(name: name)
        setupDeleteBindings()
        setupUpdateBindings()
        
        
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
                print("Cargando...")
                self.courseID = course.id
                self.courseNameTextView.text = course.name
                self.descripcionTextView.text = course.description
                self.objetivesTextView.text = course.learningObjectives
                self.scheduleTextView.text = course.schedule
                self.txtRequierements.text = course.prerequisites
                self.materialesTextField.text = course.materials.joined(separator: " ")
                self.updateFavoriteButtonUI()
                
                Task {
                    print("Loading course image from URL: \(course.imageUrl)")
                    if let image = await self.viewModel?.loadImage(for: course.imageUrl) {
                        DispatchQueue.main.async {
                            self.courseImage.image = image
                        }
                    } else {
                        print("Fallo al cargar la imagen")
                    }
                }
            }
        }
        
        
    }
    func setButtons() {
        
        title = "Detalles del Curso"
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
        
        objetivesTextView.isEditable = false
        objetivesTextView.isScrollEnabled = true
        
        // Personalización del título del curso
        courseNameTextView.isEditable = false
        courseNameTextView.isScrollEnabled = true
        
        scheduleTextView.isEditable = false
        scheduleTextView.isScrollEnabled = true
        
        courseImage.clipsToBounds = true
        courseImage.layer.cornerRadius = 20
        
        saveButton.isEnabled = false
        saveButton.isHidden = true
        
        imagePickerButton.isHidden = true
        imagePickerButton.isEnabled = false
        
        view.addSubview(activityIndicator)
        
        // Constraints para centrar el indicador de carga
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        
        
    }
    // MARK: - ACTIONS
    // MARK: - Acción para Marcar/Desmarcar Favorito
    @IBAction func markFavoriteButtonTapped(_ sender: UIButton) {
        viewModel.toggleFavorite()
        updateFavoriteButtonUI()
    }
    
    // MARK: - Toggle Edit Mode
    @IBAction func toggleEditMode(_ sender: UIButton) {
        cambiarEstados()
        
        showAlerts(title: "Modo editar", message: "Presione guardar luego de realizar los cambios. Puede cambiarlo en cualquier momento")
        

        
    }
    
    //MARK: - BOTON DE GUARDAR
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        activityIndicator.startAnimating()
        cambiarEstados()
        
        
        
        print("saveButtonTapped ejecutado")
        //let course = viewModel.course.id
        
        guard let courseID = courseID else {
               print("courseID es nil")
               return
        }

        let name = courseNameTextView.text ?? viewModel.course?.name ?? ""
        let description = descripcionTextView.text.isEmpty ? viewModel.course?.description ?? "" : descripcionTextView.text
        let learningObjectives = objetivesTextView.text.isEmpty ? viewModel.course?.learningObjectives ?? "" : objetivesTextView.text
        let schedule = scheduleTextView.text ?? viewModel.course?.schedule ?? ""
        let prerequisites = txtRequierements.text
        let materials = materialesTextField.text.isEmpty ? viewModel.course?.materials ?? [] : materialesTextField.text.split(separator: ",").map(String.init)
        let imageUrl = viewModel.course?.imageUrl ?? ""

        let updatedCourse = CourseModel(
            id: courseID,
            name: name,
            description: description!,
            learningObjectives: learningObjectives!,
            schedule: schedule,
            prerequisites: prerequisites!,
            materials: materials,
            imageUrl: imageUrl
        )
        print("Intentando actualizar curso: \(updatedCourse)")

        Task {
            print("Ejecutandose actualizacion") //Este print no se ejecuta
            await viewModel.updateCourse(courseID: courseID, updatedCourse: updatedCourse, image: selectedImage)
            print("Task Actualizada")
        }
        
        
        
        
    }
    
    //MARK: - DELETE ACTION
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let course = viewModel.course else {
            print("Course not found")
            return
        }
        let alert = UIAlertController(title: "Confirmar", message: "¿Estás seguro de eliminar este curso?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteCourse(withID: course.id)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker
    @IBAction func selectImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - Configurar bindings
    private func setupUpdateBindings() {
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.showAlert(title: "Error", message: error)
               
            }
            
        }
        viewModel.onUpdateSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.showAlert(title: "Éxito", message: "El curso se actualizó correctamente.")
                self?.updateUIWithCourseDetails()
            }
           
        }
    }
    
    
    private func setupDeleteBindings() {
        viewModel.onDeleteSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(title: "Éxito", message: "Curso eliminado exitosamente.") {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        viewModel.onDeleteError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    
    func cambiarEstados(){
        descripcionTextView.isEditable.toggle()
        txtRequierements.isEditable.toggle()
        objetivesTextView.isEditable.toggle()
        materialesTextField.isEditable.toggle()
        courseNameTextView.isEditable.toggle()
        scheduleTextView.isEditable.toggle()
        saveButton.isHidden.toggle()
        saveButton.isEnabled.toggle()
        imagePickerButton.isHidden.toggle()
        imagePickerButton.isEnabled.toggle()
        
    }
    
   
    //MARK: - Actualizar detail
    // MARK: Actualizar la interfaz de usuario
    private func updateUIWithCourseDetails() {
        guard let course = viewModel.course else { return }
        courseNameTextView.text = course.name
        descripcionTextView.text = course.description
        scheduleTextView.text = course.schedule
        txtRequierements.text = course.prerequisites
        objetivesTextView.text = course.learningObjectives
        materialesTextField.text = course.materials.joined(separator: ", ")
        
        Task {
            courseImage.image = await viewModel.loadImage(for: course.imageUrl)
        }
    }
    //MARK: - Actualizae estado de favorito
    /// Actualiza la imagen del botón de favorito según el estado del curso.
    private func updateFavoriteButtonUI() {
        guard let course = viewModel.course else { return }
        let imageName = course.isFavorite == true ? "heart.fill" : "heart"
        btnMarkFavorite.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    /// Método de ayuda para mostrar alertas.
    private func showAlerts(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
}


extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            courseImage.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

