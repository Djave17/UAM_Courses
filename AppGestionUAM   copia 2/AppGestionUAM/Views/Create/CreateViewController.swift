//
//  CreateViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 31/10/24.
//

import UIKit

class CreateViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var principalView: UIView!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var buttonAdd: UIButton! // "Agrega una imagen del curso"
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var objectivesTextView: UITextView!
    @IBOutlet weak var scheduleTextField: UITextField!
    @IBOutlet weak var prerequisitesTextView: UITextView!
    @IBOutlet weak var materialsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
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
    }
    
    private func setupUI() {
        setupHeaderView()
        setupTextFields()
        setupButtons()
        setupImagePicker()
        setupImageView()
        setupBindings()
        setUpHeaderView()
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
    }
    
    private func setupButtons() {
        saveButton.setTitle("Guardar Curso", for: .normal)
        saveButton.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 156/255, alpha: 1)
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 12
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    private func setupBindings() {
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(message: error)
            }
        }
        
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(message: "Curso creado con éxito.")
            }
        }
    }
    
    // MARK: - Button Actions
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        viewModel.name = nameTextField.text ?? ""
        viewModel.description = descriptionTextView.text
        viewModel.learningObjectives = objectivesTextView.text
        viewModel.schedule = scheduleTextField.text ?? ""
        viewModel.prerequisites = prerequisitesTextView.text
        viewModel.materials = materialsTextView.text.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        
        viewModel.createCourse()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CreateViewController: UITextViewDelegate {
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
extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
