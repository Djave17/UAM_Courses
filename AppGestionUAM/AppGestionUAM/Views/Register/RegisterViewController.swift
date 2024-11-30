//
//  RegisterViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//
import UIKit
import Combine

class RegisterViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!

    // ViewModel y Combine
    private var registerViewModel = RegisterViewModel()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
            }

    // MARK: - Configuración de bindings
    private func configureBindings() {
        // Observar errores
        registerViewModel.$errorMessage
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showAlert(title: "Error", message: errorMessage)
                }
            }
            .store(in: &cancellables)

        // Observar éxito de registro
        registerViewModel.$isRegistered
            .sink { [weak self] isRegistered in
                if isRegistered {
                    self?.showAlert(title: "Éxito", message: "Registro exitoso.") {
                        self?.navigateToCourseList()
                    }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Tap en "Register"
    @IBAction func tapOnRegister(_ sender: UIButton) {
        guard validateFields() else { return }
        registerViewModel.name = nameTextField.text ?? ""
        registerViewModel.email = emailTextField.text ?? ""
        registerViewModel.password = passwordTextField.text ?? ""
        
        Task {
            await registerViewModel.registerUser()
            
//            if let errorMessage = registerViewModel.errorMessage {
//                handleError(APIError.validationFailed(errorMessage))
//            } else if registerViewModel.isRegistered {
//                navigateToCourseList()
//            }
        }
    }


    // MARK: - Validación de Campos
    private func validateFields() -> Bool {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
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
}
