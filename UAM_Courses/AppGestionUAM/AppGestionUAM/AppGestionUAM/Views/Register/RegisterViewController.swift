//  RegisterViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private var btnCreate: UIButton!
    private var btnLogIn: UIButton!
    private let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
    
    // MARK: - Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var uamView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    // ViewModel
    private var registerViewModel = RegisterViewModel()
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        setAllElements()
        gestosKeyboard()
        
        setupTextField()
        
        //Custom Border
        registerButton.layer.cornerRadius = 10
        
        // Configuración de bordes para las textFields
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        emailTextField.layer.cornerRadius = 5
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        passwordTextField.layer.cornerRadius = 5
        
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        nameTextField.layer.cornerRadius = 5
        
        // Eventos de edición
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
    }
    
    
    // MARK: - TextField Animations
    @objc func emailTextFieldEditingDidBegin(_ sender: UITextField) {
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
    
    @objc func passwordTextFieldEditingDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
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
    
    
    @objc func nameTextFieldEditingDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
    @objc func nameTextFieldEditingDidEnd(_ sender: UITextField) {
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
    
    // MARK: - Gestos para ocultar el teclado
    func gestosKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Configuración de bindings
    private func configureBindings() {
        registerViewModel.errorMessageHandler = { [weak self] errorMessage in
            self?.showError(message: errorMessage)
        }
        
        registerViewModel.registrationStatusHandler = { [weak self] isSuccess in
            if isSuccess {
                self?.showSuccessMessage()
                self?.navigateToLogin()
            }
        }
    }
    
    // MARK: - Tap en "Register"
    @IBAction func tapOnRegister(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showCustomAlert(title: "Error", message: "Complete todos los campos.")
            return
        }
        registerViewModel.register(name: name, email: email, password: password)
    }
    
    // MARK: - Helpers
    private func showError(message: String) {
        showCustomAlert(title: "Error", message: "Todos los campos son obligatorios.")
    }
    
    private func showSuccessMessage() {
        showCustomAlert(title: "Éxito", message: "Registro exitoso")
        // Acción cuando se presiona el botón OK
        self.navigateToLogin()
        
    }
    
    // Función para crear alertas personalizadas
    func showCustomAlert(title: String, message: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        // Color personalizado
        let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
        
        // Personalizar el título
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                         NSAttributedString.Key.foregroundColor: customColor]
        let attributedTitle = NSAttributedString(string: title, attributes: titleFont)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        // Personalizar el mensaje
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                           NSAttributedString.Key.foregroundColor: customColor]
        let attributedMessage = NSAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Botón "OK" con color personalizado
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Cambiar el color del texto del botón
        okAction.setValue(customColor, forKey: "titleTextColor")
        
        // Aplicar borde personalizado a la alerta
        if let alertView = alert.view.subviews.first?.subviews.first?.subviews.first {
            alertView.layer.cornerRadius = 10
            alertView.layer.borderWidth = 2
            alertView.layer.borderColor = customColor.cgColor
        }
        
        // Presentar la alerta
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController {
                topVC.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func navigateToLogin(){
        let loginViewController = LoginViewController()
        // Bloqueamos la animación del push (animated: false)
        navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    private func setAllElements(){
        navigationItem.hidesBackButton = true
        
        
        
        // Configuración de textFields
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.cornerRadius = 6
        emailTextField.clipsToBounds = true
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 6
        passwordTextField.clipsToBounds = true
        
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.cornerRadius = 6
        nameTextField.clipsToBounds = true
        
        // Configuración del botón de registro (ya configurado en Storyboard)
        registerButton.layer.cornerRadius = 15
        registerButton.clipsToBounds = true
        
        
        
        
        // --- Configuración de los botones de navegación (Crear Cuenta e Iniciar Sesión) ---
        // Se replica la posición y medidas del Login:
        // StackView centrado horizontalmente y a 70 puntos arriba del centro vertical,
        // con ancho 340 y altura 50.
        
        // Botón "Crear Cuenta" activo con borde
        btnCreate = createButton(title: "Crear Cuenta", backgroundColor: customColor, textColor: .white)
        btnCreate.layer.borderWidth = 2
        btnCreate.layer.borderColor = customColor.cgColor
        btnCreate.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnCreate.addTarget(self, action: #selector(goToRegister(_:)), for: .touchUpInside)
        
        // Botón "Iniciar Sesión" inactivo
        btnLogIn = createButton(title: "Iniciar Sesión", backgroundColor: .white, textColor: customColor)
        btnLogIn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        btnLogIn.layer.borderWidth = 2
        btnLogIn.layer.borderColor = customColor.cgColor
        btnLogIn.addTarget(self, action: #selector(goToLoginFromRegister(_:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [btnCreate, btnLogIn])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            
            
            // Manteniendo el stackView en su posición FIJA
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            stackView.widthAnchor.constraint(equalToConstant: 340),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        
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
        // Al pulsar "Crear Cuenta" estando en Register, no se realiza navegación
        sender.isEnabled = false
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
            self.btnCreate.backgroundColor = self.customColor
            self.btnCreate.setTitleColor(.white, for: .normal)
            self.btnLogIn.backgroundColor = .white
            self.btnLogIn.setTitleColor(self.customColor, for: .normal)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sender.isEnabled = true
            }
        })
    }
    
    @objc private func goToLoginFromRegister(_ sender: UIButton) {
        sender.isEnabled = false
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
            // Animación invertida:
            // btnCreate pasa a fondo blanco y texto en customColor
            self.btnCreate.backgroundColor = .white
            self.btnCreate.setTitleColor(self.customColor, for: .normal)
            // btnLogIn pasa a fondo customColor y texto blanco
            self.btnLogIn.backgroundColor = self.customColor
            self.btnLogIn.setTitleColor(.white, for: .normal)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.navigateToLogin()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sender.isEnabled = true
            }
        })
    }
    
    private func showErrorAnimation(for textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    // MARK: - Configuración de Text Field (Iconos)
    func setupTextField() {
        // Configuración del icono de candado para el password
        let lockIcon = UIImageView(image: UIImage(systemName: "lock"))
        lockIcon.tintColor = .systemTeal
        lockIcon.contentMode = .scaleAspectFit
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: passwordTextField.frame.height))
        lockIcon.frame = CGRect(x: 10, y: (paddingView.frame.height - 20) / 2, width: 20, height: 20)
        paddingView.addSubview(lockIcon)
        
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = .always
        
        // Configuración del icono de sobre para el email
        let emailIcon = UIImageView(image: UIImage(systemName: "envelope"))
        emailIcon.tintColor = .systemTeal
        emailIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: emailTextField.frame.height))
        emailIcon.frame = CGRect(x: 10, y: (leftPaddingView.frame.height - 20) / 2, width: 20, height: 20)
        leftPaddingView.addSubview(emailIcon)
        
        emailTextField.leftView = leftPaddingView
        emailTextField.leftViewMode = .always
        
        // Configuración del icono para el name
        let nameIcon = UIImageView(image: UIImage(systemName: "person"))
        nameIcon.tintColor = .systemTeal
        nameIcon.contentMode = .scaleAspectFit
        
        let nameLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: nameTextField.frame.height))
        nameIcon.frame = CGRect(x: 10, y: (nameLeftView.frame.height - 20) / 2, width: 20, height: 20)
        nameLeftView.addSubview(nameIcon)
        
        nameTextField.leftView = nameLeftView
        nameTextField.leftViewMode = .always
    }
}
