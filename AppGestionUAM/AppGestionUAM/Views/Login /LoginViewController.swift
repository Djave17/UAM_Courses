//
//  LoginViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 31/10/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private var btnCreate: UIButton!
    private var btnLogIn: UIButton!
    private let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
    
    //MARK: OUTLETS
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
  
    //View
    @IBOutlet var viewH: UIView!
    @IBOutlet weak var bodyView: UIView!
    
    //Botones
    @IBOutlet weak var btnQuestions: UIButton!
    @IBOutlet weak var checkbox: UIButton!
  
    @IBOutlet weak var logInButton: UIButton!
    
   
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
        setupTextField()
        setAllElements()
        
        //Custom Border
        logInButton.layer.cornerRadius = 10
        
        btnQuestions.layer.cornerRadius = 10
        
        //Gesto para quitar keyborard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //Animation Email
        // Configura el borde inicial del text field
               emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
               emailTextField.layer.cornerRadius = 5
        //Animacion Password
        passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
                passwordTextField.layer.cornerRadius = 5

               // Configura los eventos de inicio y fin de edición
               emailTextField.addTarget(self, action: #selector(emailTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
               emailTextField.addTarget(self, action: #selector(emailTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        // Configura los eventos de inicio y fin de edición para passwordTextField
              passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
              passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
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
                showErrorAnimationn(for: emailTextField)
                showErrorAnimationn(for: passwordTextField)
            }
        }
        
    }
    

    
    private func handleLoginResult(_ result: Result<LoginResponse, APIError>) {
            switch result {
            case .success(_):
                
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
                  showErrorAnimationn(for: emailTextField)
                  showErrorAnimationn(for: passwordTextField)
                  
            return false
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Correo Inválido", message: "Por favor, ingresa un correo válido.")
            showErrorAnimationn(for: emailTextField)
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
    

    
    private func setAllElements(){
        //Configuracion de Botones de Navegacion  en StackView
        // Botón "Crear Cuenta" activo con borde
        btnCreate = createButton(title: "Crear Cuenta", backgroundColor: .white, textColor: customColor)

        btnCreate.layer.borderWidth = 2
        btnCreate.layer.borderColor = customColor.cgColor
        btnCreate.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnCreate.addTarget(self, action: #selector(goToRegister(_:)), for: .touchUpInside)
        
        
        
        // Botón "Iniciar Sesión" inactivo
        btnLogIn = createButton(title: "Iniciar Sesión", backgroundColor: self.customColor, textColor: .white)
        btnLogIn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        btnLogIn.layer.borderWidth = 2
        btnLogIn.layer.borderColor = customColor.cgColor
        
        
        
        
        let stackView = UIStackView(arrangedSubviews: [btnCreate, btnLogIn])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            stackView.widthAnchor.constraint(equalToConstant: 340),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
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
        
        NSLayoutConstraint.activate([
                    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
                    stackView.widthAnchor.constraint(equalToConstant: 340),
                    stackView.heightAnchor.constraint(equalToConstant: 50)
                ])
        
        
    }
    
    private func animateButton() {
        // Animación para cambiar el color de fondo y el borde
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                // Cambia el color de fondo y el texto
                self.btnCreate.backgroundColor = self.customColor // Cambia el color de fondo a customColor
                self.btnCreate.setTitleColor(.white, for: .normal) // Cambia el color del texto a blanco
                self.btnCreate.layer.borderColor = self.customColor.cgColor // Cambia el color del borde

                // También puedes hacer lo mismo con el botón de login si es necesario
                self.btnLogIn.backgroundColor = .white
                self.btnLogIn.setTitleColor(self.customColor, for: .normal)
                self.view.layoutIfNeeded() // Refresca la vista
            })
    }

    
    private func createButton(title: String, backgroundColor: UIColor, textColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }
    
    // MARK: - Acciones de navegación de botones
    @objc private func goToRegister(_ sender: UIButton) {
       
        //aqui desactivo el boton para evitar multiples toques
        // Desactiva el botón para evitar múltiples toques
           sender.isEnabled = false

           // Llama a animateButton para realizar la animación al presionar
           animateButton()

           // Después de la animación, realiza la navegación
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
               self.navigateToLogin()
               // Vuelve a habilitar el botón después de un retraso
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                   sender.isEnabled = true
               }
        }
    }
    
    
    
    func navigateToLogin(){
        let loginViewController = RegisterViewController()
        // Bloqueamos la animación del push (animated: false)
        navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    
    @IBAction func forgottenTapped(_ sender: Any) {
        
        let changePasswordViewControler = ChangePassViewController2()
        navigationController?.pushViewController(changePasswordViewControler, animated: true)
    }
    
    @IBAction func queHacerTapped(_ sender: Any) {
        
        let viewQuestion = QuestionLogInViewController(nibName: String?("QuestionLogInViewController"), bundle: nil)
        present(viewQuestion, animated: true, completion: nil)
        
    }
    
    //MARK: - Configuracion de Text Field
    func setupTextField() {
        
        let lockIcon = UIImageView(image: UIImage(systemName: "lock"))
            lockIcon.tintColor = .systemTeal
            lockIcon.contentMode = .scaleAspectFit
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: passwordTextField.frame.height))
            lockIcon.frame = CGRect(x: 10, y: (paddingView.frame.height - 20) / 2, width: 20, height: 20)
            
            paddingView.addSubview(lockIcon)
            
            passwordTextField.leftView = paddingView
            passwordTextField.leftViewMode = .always
        
        let emailIcon = UIImageView(image: UIImage(systemName: "envelope"))
        emailIcon.tintColor = .systemTeal
        emailIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: emailTextField.frame.height))
        emailIcon.frame = CGRect(x: 10, y: (leftPaddingView.frame.height - 20) / 2, width: 20, height: 20)
        leftPaddingView.addSubview(emailIcon)
        
        emailTextField.leftView = leftPaddingView
        emailTextField.leftViewMode = .always

        // ojo derecha
        let hidePasswordButton = UIButton(type: .system)
        hidePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        hidePasswordButton.tintColor = .systemTeal
        hidePasswordButton.frame = CGRect(x: -5, y: 0, width: 28, height: passwordTextField.frame.height)  // Aumentar un poco el ancho

        // ojo derecha
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: emailTextField.frame.height))
        rightPaddingView.addSubview(hidePasswordButton)
        
        passwordTextField.rightView = rightPaddingView
        passwordTextField.rightViewMode = .always

        // hide/show tapped password
        hidePasswordButton.addAction(UIAction(handler: { [weak self] _ in
            self?.togglePasswordVisibility(for: self?.passwordTextField, button: hidePasswordButton)
        }), for: .touchUpInside)
    }

    func togglePasswordVisibility(for textField: UITextField?, button: UIButton) {
        guard let textField = textField else { return }
        
       //cambiar vis car
        textField.isSecureTextEntry.toggle()
        
        // change tapped
        let eyeImage = UIImage(systemName: textField.isSecureTextEntry ? "eye" : "eye.fill")
        button.setImage(eyeImage, for: .normal)
    }
    
    //MARK: - Configuracion Animaciones Text Field
    @objc func emailTextFieldEditingDidBegin(_ sender: UITextField) {
          // Cuando el campo es tocado, cambiamos el borde a teal con animación
          UIView.animate(withDuration: 0.3) {
              sender.layer.borderColor = UIColor.systemTeal.cgColor
          }
      }

      @objc func emailTextFieldEditingDidEnd(_ sender: UITextField) {
          // Cuando el campo deja de ser tocado, se valida si el campo está vacío
            if sender.text?.isEmpty ?? true {
                // Si el campo está vacío, lo marcamos con color rojo para indicar un error
                showErrorAnimation(for: sender)
            } else {
                // Si el campo no está vacío, restauramos el borde al color gris predeterminado
                UIView.animate(withDuration: 0.3) {
                    sender.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor  // Borde gris por defecto
                }
            }
      }
    
    // Animación para passwordTextField cuando se toca
       @objc func passwordTextFieldEditingDidBegin(_ sender: UITextField) {
           UIView.animate(withDuration: 0.3) {
               sender.layer.borderColor = UIColor.systemTeal.cgColor
           }
       }

       // Animación para passwordTextField cuando deja de ser tocado
       @objc func passwordTextFieldEditingDidEnd(_ sender: UITextField) {
           if sender.text?.isEmpty ?? true {
                  // Si el campo está vacío, lo marcamos con color rojo para indicar un error
                  showErrorAnimation(for: sender)
              } else {
                  // Si el campo no está vacío, restauramos el borde al color gris predeterminado
                  UIView.animate(withDuration: 0.3) {
                      sender.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor  // Borde gris muy tenue
                  }
              }
       }

    private func showErrorAnimation(for textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }

    
    // Función para mostrar animación de error (borde rojo)
    private func showErrorAnimationn(for textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.red.cgColor // Borde rojo para error
            textField.layer.borderWidth = 2.0 // Ancho de borde para hacer más visible el error
        }
    }
    
    private func setupCheckbox() {
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
