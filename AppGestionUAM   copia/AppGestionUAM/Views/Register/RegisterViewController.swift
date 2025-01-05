//
//  RegisterViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//
import UIKit


class RegisterViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cifTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!

    //ViewModel 
    private var registerViewModel = RegisterViewModel()
   

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
            }

    // MARK: - Configuración de bindings
    private func configureBindings() {
        registerViewModel.errorMessageHandler = { [weak self] errorMessage in
                   self?.showError(message: errorMessage)
               }

               registerViewModel.registrationStatusHandler = { [weak self] isSuccess in
                   if isSuccess {
                       self?.navigateToLogin()
                   }
               }
    }

    // MARK: - Tap en "Register"
    @IBAction func tapOnRegister(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
                    let email = emailTextField.text, !email.isEmpty,
                    let password = passwordTextField.text, !password.isEmpty else {
                    showError(message: "Please fill in all fields.")
                    return
                }

        registerViewModel.register(name: name, email: email, password: password)
    }

    
    // MARK: - Helpers
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

        private func showSuccessMessage() {
            let alert = UIAlertController(title: "Exito", message: "Registro exitoso!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigateToLogin()
            }))
            present(alert, animated: true)
        }
    // MARK: - Navegación
    private func navigateToCourseList() {
        guard let courseListViewController = storyboard?.instantiateViewController(withIdentifier: "CourseListViewController") as? CourseListViewController else {
            return
        }
        navigationController?.pushViewController(courseListViewController, animated: true)
    }
    @IBAction func tapOnLogin(_ sender: Any) {
        navigateToLogin()
    }
    func navigateToLogin(){
        let courseListViewController = CourseListViewController()
        navigationController?.pushViewController(courseListViewController, animated: true)
    }
}
