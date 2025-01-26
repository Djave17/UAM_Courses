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
    @IBOutlet weak var btnQuestionLogIn: UIButton!
    @IBOutlet weak var btnQuestion: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    //View
    @IBOutlet var viewH: UIView!
    @IBOutlet weak var bodyView: UIView!
    
    //Botones
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    // ViewModel
    //private var loginViewModel = LoginViewModel()
    private var loginController = LoginController()
    
    
    // MARK: - Ciclo de Vida
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAllElements()
        
        //Borde para botones
        btnQuestionLogIn.layer.cornerRadius = 10
        //Gesto para quitar
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
    // MARK: - Configurar Enlaces con el ViewModel
    
    
    // MARK: - Tap en Log In
    @IBAction func tapOnLogin(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else{ return }
        
        Task {
            let response = await loginController.login(email: email, password: password)
            if response != nil {
                navigateToCourseList()
                
            } else{
                print("Fallo en tapOnLogin")
                handleError(APIError.validationFailed("Error al intentar loggearse"))
            }
        }
        
    }
    
    private func handleLoginResult(_ result: Result<LoginResponse, APIError>) {
            switch result {
            case .success(let response):
                saveToken(response.token)
                showAlert(title: "Éxito", message: "Inicio de sesión exitoso.") {
                    self.navigateToCourseList()
                }
            case .failure(let error):
                showAlert(title: "Error", message: error.errorDescription ?? "Error desconocido.")
        }
    }
    
    // MARK: - TOKEN
    private func saveToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: "authToken")
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
    }
    @IBAction func forgottenTapped(_ sender: Any) {
        
        let changePasswordViewControler = ChangePasswordViewController()
        navigationController?.pushViewController(changePasswordViewControler, animated: true)
    }
    @IBAction func queHacerTapped(_ sender: Any) {
        let questionLogInViewController = QuestionLogInViewController()
        navigationController?.pushViewController(questionLogInViewController, animated: true)
        
    }
    // MARK: - Configuracion de Onboarding Present de Question
    
    @IBAction func btnQuestionn(_ sender: Any) {
        let viewQuestion = QuestionLogInViewController(nibName: String?("QuestionLogInViewController"), bundle: nil)
        present(viewQuestion, animated: true, completion: nil)
    }
    
}
