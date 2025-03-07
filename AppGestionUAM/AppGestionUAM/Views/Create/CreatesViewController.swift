//
//  CreatesViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 29/1/25.
//

//
//  CreateViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 31/10/24.
//

import UIKit

class CreatesViewController: UIViewController {
    
    //MARK: - Outlets
    //@IBOutlet var principalView: UIView!
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var buttonAdd: UIButton! // "Agrega una imagen del curso"
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scheduleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var objectivesTextView: UITextView!
    @IBOutlet weak var prerequisitesTextView: UITextView!
    @IBOutlet weak var materialsTextView: UITextView!
    
    
    @IBOutlet weak var materialsTextField: UITextField!
    @IBOutlet weak var requierementsTextField: UITextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - Activity indicator (Carga)
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Image View for Selected Image
    private let courseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // Ocultarlo inicialmente
        return imageView
    }()

    // MARK: - ImagePicker
    private var selectedImage: UIImage?
    private let imagePicker = UIImagePickerController()
    private var viewModel = CreateCourseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        descriptionTextView.layer.cornerRadius = 5
        
        objectivesTextView.layer.borderWidth = 1
        objectivesTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        objectivesTextView.layer.cornerRadius = 5
        
        prerequisitesTextView.layer.borderWidth = 1
        prerequisitesTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        prerequisitesTextView.layer.cornerRadius = 5
        
        materialsTextView.layer.borderWidth = 1
        materialsTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        materialsTextView.layer.cornerRadius = 5
        
        vwInfo.layer.cornerRadius = 5
        vwInfo.clipsToBounds = true
        
        // Establecer el título en la barra de navegación
            self.title = "Añadir Cursos"
        
        // Configurar la apariencia de la barra de navegación
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Cambiar el color del título de la vista
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        
        // Cambiar el color del botón Back y su flecha
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        navigationController?.navigationBar.tintColor = .systemTeal
        
        // Aplicar la configuración a la barra de navegación
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    private func setupUI() {
        setupHeaderView()
        setupTextFields()
        setupButtons()
        setupImagePicker()
        setupImageView()
        setupBindings()
        setUpHeaderView()
        gestosKeyboard()
        
        view.addSubview(activityIndicator)
        
        // Constraints para centrar el indicador de carga
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
  
    
    
   
       
    
    func gestosKeyboard(){
        //Gesto para quitar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func esconderKeyboard(){
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    private func setupHeaderView() {
        headerView.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 156/255, alpha: 1)
        views.backgroundColor = .white
    }

    private func setupImageView() {
        headerView.addSubview(courseImageView)

        NSLayoutConstraint.activate([
            courseImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            courseImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            courseImageView.widthAnchor.constraint(equalToConstant: 340),
            courseImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setUpHeaderView() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 15
    }

    private func setupTextFields() {
        nameTextField.placeholder = "Nombre del curso"
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.cornerRadius = 12
        nameTextField.clipsToBounds = true
        
        descriptionTextView.text = "Descripción completa del curso"
        descriptionTextView.textColor = .lightGray
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 12
        descriptionTextView.delegate = self
        
        objectivesTextView.text = "Objetivos de aprendizaje"
        objectivesTextView.textColor = .lightGray
        objectivesTextView.clipsToBounds = true
        objectivesTextView.layer.cornerRadius = 12
        objectivesTextView.delegate = self
        
        scheduleTextField.placeholder = "Horario del curso"
        scheduleTextField.borderStyle = .roundedRect
        scheduleTextField.clipsToBounds = true
        scheduleTextField.layer.cornerRadius = 12
        
        prerequisitesTextView.text = "Requisitos o prerrequisitos"
        prerequisitesTextView.textColor = .lightGray
        prerequisitesTextView.delegate = self
        prerequisitesTextView.layer.cornerRadius = 12
        prerequisitesTextView.clipsToBounds = true
        
        materialsTextView.text = "URLs de materiales (uno por línea)"
        materialsTextView.textColor = .lightGray
        materialsTextView.delegate = self
        materialsTextView.layer.cornerRadius = 12
        materialsTextView.clipsToBounds = true
        
        title = "Crear Curso"
    }
    
    private func setupButtons() {
        let checkImage = UIImage(systemName: "checkmark") // Solo el check sin círculo
          saveButton.setImage(checkImage, for: .normal)
          saveButton.clipsToBounds = true
          saveButton.layer.cornerRadius = 12
         saveButton.translatesAutoresizingMaskIntoConstraints = false
         saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
         saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    private func setupBindings() {
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.enableSaveButton()

                // Crear el alerta con personalización
                let alert = UIAlertController(title: "\n\nError", message: error, preferredStyle: .alert)

                // Crear el icono de error (puedes usar un icono de error en lugar de checkmark)
                let errorImage = UIImage(systemName: "xmark.circle.fill")?
                    .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
                let imageView = UIImageView(image: errorImage)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false

                // Agregar el icono a la vista del alert
                alert.view.addSubview(imageView)

                // Aplicar restricciones para el icono (más arriba)
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                    imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15), // Ícono más arriba
                    imageView.widthAnchor.constraint(equalToConstant: 40),  // Tamaño de ícono
                    imageView.heightAnchor.constraint(equalToConstant: 40)
                ])

                // Botón OK con color personalizado
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Aquí puedes agregar alguna acción si es necesario, como recargar la vista o similar
                }
                okAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
                alert.addAction(okAction)

                // Presentar en el hilo principal
                self?.present(alert, animated: true)
            }
        }
        
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.enableSaveButton()
                self?.showAlertWithNavigation(message: "Nuevo curso disponible.")
            }
        }
    }

    
    // MARK: - Button Actions
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        sender.isEnabled = false
        activityIndicator.startAnimating()
        viewModel.name = nameTextField.text ?? ""
        viewModel.description = descriptionTextView.text
        viewModel.learningObjectives = objectivesTextView.text
        viewModel.schedule = scheduleTextField.text ?? ""
        viewModel.prerequisites = prerequisitesTextView.text
        viewModel.materials = materialsTextView.text.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        
        viewModel.createCourse()
        
        
        
    }
    
    private func showAlertWithNavigation(message: String) {
        let alert = UIAlertController(title: "\n\nÉxito", message: message, preferredStyle: .alert)

        // Crear el icono de check
        let checkImage = UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: checkImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Agregar el icono a la vista del alert
        alert.view.addSubview(imageView)

        // Aplicar restricciones para el icono (más arriba)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15), // Ícono más arriba
            imageView.widthAnchor.constraint(equalToConstant: 40),  // Tamaño de ícono
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Botón OK con color personalizado
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navegateToCourseList()
        }
        okAction.setValue(UIColor.systemTeal, forKey: "titleTextColor")
        alert.addAction(okAction)

        // Presentar en el hilo principal
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    
    
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Crear Curso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
        present(alert, animated: true)
    }
    
    
    private func navegateToCourseList(){
        let courseVC = CourseListViewController()
        navigationController?.pushViewController(courseVC, animated: true)
    }
    
    private func enableSaveButton() {
        saveButton.isEnabled = true
    }
}

// MARK: - UITextViewDelegate
extension CreatesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch textView {
            case descriptionTextView:
                textView.text = "Descripción completa del curso"
            case objectivesTextView:
                textView.text = "Objetivos de aprendizaje"
            case prerequisitesTextView:
                textView.text = "Requisitos o prerrequisitos"
            case materialsTextView:
                textView.text = "URLs de materiales (uno por línea)"
            default:
                break
            }
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreatesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.selectedImage = image
            courseImageView.image = image // Mostrar la imagen seleccionada en el ImageView
            courseImageView.isHidden = false // Mostrar el ImageView
            buttonAdd.isHidden = true // Ocultar el botón y el texto
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
}
