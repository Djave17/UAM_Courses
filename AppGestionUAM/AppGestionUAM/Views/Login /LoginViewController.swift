//
//  LoginViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 31/10/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    
    //MARK: OUTLETS
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    //View
    @IBOutlet var viewH: UIView!
    @IBOutlet weak var bodyView: UIView!
    
    //Botones
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var hidePasswordButton: UIButton!
    //MARK: - Activity indicator (Carga)
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //MARK: -ViewModel
    private var loginController = LoginController()
    
    
    // MARK: - Ciclo de Vida
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ocultar texto al inicio
        passwordTextField.isSecureTextEntry = true
        
        setupCheckbox()
        toggleImageButton()
        
        setAllElements()
        
        //Gesto para quitar keyborard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Limpiar los campos de texto para usuario y contraseña
            emailTextField.text = ""
            passwordTextField.text = ""
       }
    //MARK: - Hide keyboard
    @objc func hideKeyboard() {
           view.endEditing(true)
    }

    // MARK: - Tap en Log In
    @IBAction func tapOnLogin(_ sender: UIButton) {
        activityIndicator.startAnimating()
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else{ return }
        
        Task {
            let response = await loginController.login(email: email, password: password)
            
            if response != nil {
                navigateToCourseList()
                self.activityIndicator.stopAnimating()
                
            } else{
                self.activityIndicator.stopAnimating()
                print("Fallo en tapOnLogin")
                handleError(APIError.validationFailed("Error al intentar loggearse"))
            }
        }
        
    }
    
    private func handleLoginResult(_ result: Result<LoginResponse, APIError>) {
            switch result {
            case .success(let response):
                
                showAlert(title: "Éxito", message: "Inicio de sesión exitoso.") {
                    self.navigateToCourseList()
                }
            case .failure(let error):
                showAlert(title: "Error", message: error.errorDescription ?? "Error desconocido.")
        }
    }
    


    // MARK: - Validación de Campos
    private func validateFields() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Campos Vacíos", message: "Por favor, completa todos los campos.")
            return false
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Correo Inválido", message: "Por favor, ingresa un correo válido.")
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    
    
    // MARK: - Navegación
    private func navigateToCourseList() {
        let courseListViewController = CourseListViewController()
        navigationController?.pushViewController(courseListViewController, animated: true)
    }
    
    // MARK: - Alert Helper
    
    @IBAction func tapOnRegister(_ sender: Any) {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    private func setAllElements(){
        //Set de la imagen
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        //Email textfield
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.cornerRadius = 5
        emailTextField.clipsToBounds = true
        
        //Password Textfield
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.clipsToBounds = true
        
        //Login Button
        logInButton.layer.cornerRadius = 10
        logInButton.clipsToBounds = true
        navigationItem.hidesBackButton = true
        
        view.addSubview(activityIndicator)
        
        // Constraints para centrar el indicador de carga
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
    }
    @IBAction func forgottenTapped(_ sender: Any) {
        
        let changePasswordViewControler = ChangePasswordViewController()
        navigationController?.pushViewController(changePasswordViewControler, animated: true)
    }
    @IBAction func queHacerTapped(_ sender: Any) {
        
        let viewQuestion = QuestionLogInViewController(nibName: String?("QuestionLogInViewController"), bundle: nil)
        present(viewQuestion, animated: true, completion: nil)
        
    }
    
    
    @IBAction func hideEmail(_ sender: Any) {
        emailTextField.isSecureTextEntry.toggle()
    }
    @IBAction func hidePassword(_ sender: Any) {
        // Cambiar el estado de isSecureTextEntry
        passwordTextField.isSecureTextEntry.toggle()
        hidePasswordButton.isSelected = true
        
        
    }
    
    func toggleImageButton(){
        
        hidePasswordButton.setImage(UIImage(named: "eye"), for: .normal)
        
        hidePasswordButton.setImage(UIImage(named: "eye.slash.fill"), for: .selected)
        
        
    }
    private func setupCheckbox() {
        // Configurar la imagen del checkbox (desmarcado por defecto)
        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)

        checkbox.tintColor = .systemTeal // Color teal para el icono
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        
       
        
    }

    // Acción para alternar el checkbox
    @objc private func toggleCheckbox() {
        checkbox.isSelected.toggle()
    }
}





