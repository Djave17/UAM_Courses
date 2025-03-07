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
        // Cambiar el color del botón Back y su flecha
        navigationController?.navigationBar.tintColor = .systemTeal
       
        print("DetailViewController cargado, courseID: \(courseID ?? "nil")")
        setButtons()
        viewModel = CourseDetailViewModel()
        loadCourseDetails(name: name)
        setupDeleteBindings()
        setupUpdateBindings()
        
        self.title = "Detalles del Curso"
           let appearance = UINavigationBarAppearance()
           
           // Cambiar el color del título de la vista
           appearance.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
           
           appearance.configureWithOpaqueBackground() // Configura el fondo opaco
           appearance.backgroundColor = .white // Si deseas que el fondo sea blanco
           appearance.shadowColor = .clear
           
           // Asegúrate de aplicar los cambios tanto en el estándar como en el scrollEdgeAppearance
           navigationController?.navigationBar.standardAppearance = appearance
           navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let hairline = findHairlineImageViewUnder(navigationController?.navigationBar) {
            hairline.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Asegurarse de que la "hairline" se mantenga oculta después del layout
        if let hairline = findHairlineImageViewUnder(navigationController?.navigationBar) {
            hairline.isHidden = true
        }
    }

    // Función recursiva para encontrar la "hairline"
    private func findHairlineImageViewUnder(_ view: UIView?) -> UIImageView? {
        guard let view = view else { return nil }
        if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
            return imageView
        }
        for subview in view.subviews {
            if let found = findHairlineImageViewUnder(subview) {
                return found
            }
        }
        return nil
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
        
        //title = "Detalles del Curso"
        // Configuración de los botones y vistas
        recursosButton.clipsToBounds = true
        recursosButton.layer.cornerRadius = 12
        
        editButton.layer.cornerRadius = 12
        editButton.clipsToBounds = true
        
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        
        deleteButton.layer.cornerRadius = 12
        deleteButton.clipsToBounds = true 
        
        // Configuración de los textViews
        descripcionTextView.isEditable = false
        descripcionTextView.isScrollEnabled = false
        
        txtRequierements.isEditable = false
        txtRequierements.isScrollEnabled = false
        
        materialesTextField.isEditable = false
        materialesTextField.isScrollEnabled = false
        
        objetivesTextView.isEditable = false
        objetivesTextView.isScrollEnabled = false
        
        // Personalización del título del curso
        courseNameTextView.isEditable = false
        courseNameTextView.isScrollEnabled = false
        
        scheduleTextView.isEditable = false
        scheduleTextView.isScrollEnabled = false
        
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
    
    // Función separada para mostrar alertas con el icono de lápiz
    private func showAlertWithPencilIcon(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "\n\nModo Editar", message: message, preferredStyle: .alert)

           // Crear el icono de lápiz
           let pencilImage = UIImage(systemName: "pencil.circle.fill")?
               .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
           let imageView = UIImageView(image: pencilImage)
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false

           // Agregar el icono a la vista del alert
           alert.view.addSubview(imageView)

           // Aplicar restricciones para el icono
           NSLayoutConstraint.activate([
               imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
               imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15), // Ícono más arriba
               imageView.widthAnchor.constraint(equalToConstant: 40),  // Tamaño del ícono
               imageView.heightAnchor.constraint(equalToConstant: 40)
           ])

           // Botón OK con color personalizado
           let okAction = UIAlertAction(title: "OK", style: .default)
           okAction.setValue(UIColor.systemTeal, forKey: "titleTextColor")
           alert.addAction(okAction)

           // Presentar en el hilo principal
           DispatchQueue.main.async {
               self.present(alert, animated: true)
           }
       }

    // MARK: - Toggle Edit Mode
    @IBAction func toggleEditMode(_ sender: UIButton) {
        cambiarEstados()
        
        // Llamar al método de alerta con el título y mensaje que necesites
        showAlertWithPencilIcon(title: "Modo Editar", message: "Presione guardar luego de realizar los cambios.")
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
            
            // Detener animación y reactivar botón
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                        self.activityIndicator.stopAnimating()
                        
                        // Mostrar la alerta de éxito
                        self.showSaveSuccessAlert(message: "Los cambios se han guardado correctamente.")
                    }
                }
            }
        

private func showSaveSuccessAlert(message: String) {
    let alert = UIAlertController(title: "\n\nÉxito", message: message, preferredStyle: .alert)

        // Crear el icono de check
        let checkImage = UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: checkImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Agregar el icono a la vista del alert
        alert.view.addSubview(imageView)

        // Aplicar restricciones para el icono
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Botón OK sin acción, solo cierra la alerta
        let okAction = UIAlertAction(title: "OK", style: .default)
        okAction.setValue(UIColor.systemTeal, forKey: "titleTextColor")
        alert.addAction(okAction)

        // Presentar en el hilo principal
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - DELETE ACTION
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let course = viewModel.course else {
            print("Course not found")
            return
        }
        // Crear el alerta con icono de basura para la confirmación
           let alert = UIAlertController(title: "\n\nConfirmar", message: "¿Estás seguro de eliminar este curso?", preferredStyle: .alert)

           // Crear el icono de basura
           let trashImage = UIImage(systemName: "trash.circle.fill")?
               .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
           let imageView = UIImageView(image: trashImage)
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false

           // Agregar el icono a la vista del alert
           alert.view.addSubview(imageView)

           // Aplicar restricciones para el icono
           NSLayoutConstraint.activate([
               imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
               imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15),
               imageView.widthAnchor.constraint(equalToConstant: 40),
               imageView.heightAnchor.constraint(equalToConstant: 40)
           ])

        // Acción de cancelar con color teal
           let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
           cancelAction.setValue(UIColor.systemTeal, forKey: "titleTextColor")
           alert.addAction(cancelAction)

           // Acción de eliminar con estilo destructivo y color teal
           let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive, handler: { [weak self] _ in
               guard let self = self else { return }
               self.viewModel.deleteCourse(withID: course.id)
           })
           deleteAction.setValue(UIColor.systemTeal, forKey: "titleTextColor")
           alert.addAction(deleteAction)

           // Presentar la alerta en el hilo principal
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
                    
                    // Crear el alerta con personalización para el error
                    let alert = UIAlertController(title: "\n\nError", message: error, preferredStyle: .alert)

                    // Crear el icono de error
                    let errorImage = UIImage(systemName: "xmark.circle.fill")?
                        .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
                    let imageView = UIImageView(image: errorImage)
                    imageView.contentMode = .scaleAspectFit
                    imageView.translatesAutoresizingMaskIntoConstraints = false

                    // Agregar el icono a la vista del alert
                    alert.view.addSubview(imageView)

                    // Aplicar restricciones para el icono
                    NSLayoutConstraint.activate([
                        imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                        imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15), // Ícono más arriba
                        imageView.widthAnchor.constraint(equalToConstant: 40),  // Tamaño de ícono
                        imageView.heightAnchor.constraint(equalToConstant: 40)
                    ])

                    // Botón OK con color personalizado
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        // Aquí puedes agregar alguna acción si es necesario
                    }
                    okAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
                    alert.addAction(okAction)

                    // Presentar en el hilo principal
                    self?.present(alert, animated: true)
                }
            }
            
           viewModel.onUpdateSuccess = { [weak self] in
               DispatchQueue.main.async {
                   self?.activityIndicator.stopAnimating()
                   self?.showSaveSuccessAlert(message: "El curso se actualizó correctamente.") // Usa la alerta personalizada
                   self?.updateUIWithCourseDetails()
               }
           }
       }
    
    
    private func setupDeleteBindings() {
        viewModel.onDeleteSuccess = { [weak self] in
               DispatchQueue.main.async {
                   // Crear el alerta con icono de basura para la eliminación exitosa
                   let alert = UIAlertController(title: "\n\nÉxito", message: "Curso eliminado exitosamente.", preferredStyle: .alert)

                   // Crear el icono de basura
                   let trashImage = UIImage(systemName: "trash.circle.fill")?
                       .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
                   let imageView = UIImageView(image: trashImage)
                   imageView.contentMode = .scaleAspectFit
                   imageView.translatesAutoresizingMaskIntoConstraints = false

                   // Agregar el icono a la vista del alert
                   alert.view.addSubview(imageView)

                   // Aplicar restricciones para el icono
                   NSLayoutConstraint.activate([
                       imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                       imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15), // Ícono más arriba
                       imageView.widthAnchor.constraint(equalToConstant: 40),  // Tamaño de ícono
                       imageView.heightAnchor.constraint(equalToConstant: 40)
                   ])

                   // Botón OK con color personalizado
                   let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                       // Navegar atrás después de la eliminación exitosa
                       self?.navigationController?.popViewController(animated: true)
                   }
                   okAction.setValue(UIColor.systemTeal, forKey: "titleTextColor")
                   alert.addAction(okAction)

                   // Presentar la alerta en el hilo principal
                   self?.present(alert, animated: true)
               }
           }
        
        viewModel.onDeleteError = { [weak self] error in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    
                    // Crear el alerta con personalización para el error
                    let alert = UIAlertController(title: "\n\nError", message: error.localizedDescription, preferredStyle: .alert)

                    // Crear el icono de error
                    let errorImage = UIImage(systemName: "xmark.circle.fill")?
                        .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
                    let imageView = UIImageView(image: errorImage)
                    imageView.contentMode = .scaleAspectFit
                    imageView.translatesAutoresizingMaskIntoConstraints = false

                    // Agregar el icono a la vista del alert
                    alert.view.addSubview(imageView)

                    // Aplicar restricciones para el icono
                    NSLayoutConstraint.activate([
                        imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                        imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15), // Ícono más arriba
                        imageView.widthAnchor.constraint(equalToConstant: 40),  // Tamaño de ícono
                        imageView.heightAnchor.constraint(equalToConstant: 40)
                    ])

                    // Botón OK con color personalizado
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        // Aquí puedes agregar alguna acción si es necesario
                    }
                    okAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
                    alert.addAction(okAction)

                    // Presentar en el hilo principal
                    self?.present(alert, animated: true)
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
        editButton.isEnabled.toggle()
        deleteButton.isEnabled.toggle()
        editButton.isHidden.toggle()
        deleteButton.isHidden.toggle()
        
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

