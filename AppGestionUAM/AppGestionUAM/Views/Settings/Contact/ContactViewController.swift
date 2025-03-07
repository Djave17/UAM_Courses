import UIKit
import AVFoundation

class ContactViewController: UIViewController, UITextViewDelegate {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var remitenteTextField: UITextField!
    var asuntoTextField: UITextField!
    var descripcionTextView: UITextView!
    
    private let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        self.title = "Soporte Técnico"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: customColor] // Título en color teal
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: customColor] // Botón Back en color teal
        
        navigationController?.navigationBar.tintColor = customColor // Flecha del botón Back en color teal
        
        navigationController?.navigationBar.standardAppearance = { let appearance = UINavigationBarAppearance(); appearance.configureWithOpaqueBackground(); appearance.backgroundColor = .systemBackground; return appearance }()
        
        navigationController?.navigationBar.tintColor = customColor // Flecha del botón Back en color teal
        navigationController?.navigationBar.shadowImage = UIImage()
        appearance.shadowColor = customColor
        
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupUI()
    }
    
    
    
    private func setupUI() {
        view.backgroundColor = .white
        remitenteTextField = createTextField()
        asuntoTextField = createTextField()
        descripcionTextView = UITextView()
        
        // Establecer fuente más grande para el UITextView
        descripcionTextView.font = UIFont.systemFont(ofSize: 18)
        
        descripcionTextView.delegate = self
        
        // Mensaje superior centrado
        let headerLabel = UILabel()
        headerLabel.text = "Contáctanos"
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = customColor
        headerLabel.textAlignment = .center
        
        // Función para crear etiquetas
        func createLabel(text: String) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textColor = customColor
            return label
        }
        
        // Función para crear TextField
        func createTextField() -> UITextField {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 0.5).cgColor // Más opacidad
            textField.layer.cornerRadius = 5
            return textField
        }
        
        // Aplicar el mismo estilo de borde que el UITextField
        descripcionTextView.layer.borderWidth = 1.0
        descripcionTextView.layer.borderColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 0.5).cgColor
        descripcionTextView.layer.cornerRadius = 5
        descripcionTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let enviarButton = UIButton(type: .system)
        enviarButton.setTitle("Enviar", for: .normal)
        enviarButton.setTitleColor(.white, for: .normal)
        enviarButton.backgroundColor = customColor
        enviarButton.layer.cornerRadius = 10
        enviarButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        enviarButton.widthAnchor.constraint(equalToConstant: 60).isActive = true // Botón más pequeño
        enviarButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular) // Tamaño de letra más grande y en negrita
        enviarButton.addTarget(self, action: #selector(enviarFormulario), for: .touchUpInside)
        
        // Crear las etiquetas
        let remitenteLabel = createLabel(text: "Remitente")
        let asuntoLabel = createLabel(text: "Asunto")
        let descripcionLabel = createLabel(text: "Descripción")
        
        // StackView para organizar todo verticalmente
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel, remitenteLabel, remitenteTextField,
            asuntoLabel, asuntoTextField,
            descripcionLabel, descripcionTextView,
            enviarButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Configurar restricciones
        if let playerLayerFrameMaxY = playerLayer?.frame.maxY {
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: playerLayerFrameMaxY + 40), // Desplazamos más abajo
                enviarButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
            ])
        } else {
            // Si playerLayer es nil, ajustamos el stackView sin dependencias de playerLayer
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20), // Ajuste básico
                enviarButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
            ])
        }
        
        // Agregar un gesto de toque fuera de los campos
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
        
        // Configuración del icono de sobre para el email
        let emailIcon = UIImageView(image: UIImage(systemName: "envelope"))
        emailIcon.tintColor = .systemTeal
        emailIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: remitenteTextField.frame.height))
        emailIcon.frame = CGRect(x: 10, y: (leftPaddingView.frame.height - 20) / 2, width: 20, height: 20)
        leftPaddingView.addSubview(emailIcon)
        
        remitenteTextField.leftView = leftPaddingView
        remitenteTextField.leftViewMode = .always
        
        let left = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: asuntoTextField.frame.height))
        
        // Create an UIImageView for the exclamation mark icon
        let exclamationmark = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        exclamationmark.tintColor = .systemTeal
        exclamationmark.frame = CGRect(x: 10, y: (left.frame.height - 20) / 2, width: 20, height: 20)
        
        // Add the exclamation mark icon to the left view
        left.addSubview(exclamationmark)
        
        // Set the left view as the left view of the text field
        asuntoTextField.leftView = left
        asuntoTextField.leftViewMode = .always
        
        
        
    }
    
    // Función para mostrar la animación de error (bordes rojos)
    private func showErrorAnimation(for textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    /*remitenteTextField
     asuntoTextField
     descripcionTextView */
    
    
    @objc private func enviarFormulario() {
        var hayError = false
        
        // Comprobar si los campos están vacíos y marcar con borde rojo
        if remitenteTextField.text?.isEmpty ?? true {
            showErrorAnimation(for: remitenteTextField)
            hayError = true
        } else {
            // Si el campo no está vacío, restablecer el borde a su color original
            resetErrorAnimation(for: remitenteTextField)
        }
        
        if asuntoTextField.text?.isEmpty ?? true {
            showErrorAnimation(for: asuntoTextField)
            hayError = true
        } else {
            // Si el campo no está vacío, restablecer el borde a su color original
            resetErrorAnimation(for: asuntoTextField)
        }
        
        if descripcionTextView.text.isEmpty {
            showErrorAnimation(for: descripcionTextView)
            hayError = true
        } else {
            // Si el campo no está vacío, restablecer el borde a su color original
            resetErrorAnimation(for: descripcionTextView)
        }
        
        // Si hay error, mostrar alerta de error
        if hayError {
            mostrarAlertaError()
        } else {
            // Si no hay error, mostrar mensaje de éxito y limpiar los campos
            mostrarAlertaExito()
        }
        
        remitenteTextField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        asuntoTextField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        
    }
    
    @objc private func didChangeText(sender: UITextField) {
        // Si el campo tiene texto, restablecemos el borde a su color original
        if let text = sender.text, !text.isEmpty {
            resetErrorAnimation(for: sender)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            resetErrorAnimation(for: textView)
        }
    }
    
    private func resetErrorAnimation(for view: UIView) {
        UIView.animate(withDuration: 0.3) {
            view.layer.borderColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 0.5).cgColor
        }
    }
    
    private func mostrarAlertaError() {
        let alert = UIAlertController(title: "\n\nError", message: "Es obligatorio llenar todos los campos.", preferredStyle: .alert)
        
        // Crear el icono de error (exclamación)
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
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Acción de OK
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.actions.last?.setValue(UIColor.systemRed, forKey: "titleTextColor")
        present(alert, animated: true, completion: nil)
    }
    
    private func mostrarAlertaExito() {
        let alert = UIAlertController(title: "\n\nÉxito", message: "Correo enviado.", preferredStyle: .alert)
        
        // Crear el icono de éxito (checkmark)
        let successImage = UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: successImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Agregar el icono a la vista del alert
        alert.view.addSubview(imageView)
        
        // Aplicar restricciones para el icono
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15), // Ícono más arriba
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Acción de OK
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.remitenteTextField.text = ""
            self.asuntoTextField.text = ""
            self.descripcionTextView.text = ""
            self.remitenteTextField.becomeFirstResponder()
        }))
        
        alert.actions.last?.setValue(UIColor.systemTeal, forKey: "titleTextColor")
        
        present(alert, animated: true, completion: nil)
    }
    
    private func limpiarCampos() {
        remitenteTextField.text = ""
        asuntoTextField.text = ""
        descripcionTextView.text = ""
    }
    
    
    @objc func handleTapOutside() {
        // Verificar si los campos están vacíos y cambiar el color del borde a rojo
        if remitenteTextField.text?.isEmpty ?? true {
            showErrorAnimation(for: remitenteTextField)
        }
        
        if asuntoTextField.text?.isEmpty ?? true {
            showErrorAnimation(for: asuntoTextField)
        }
        
        if descripcionTextView.text.isEmpty {
            showErrorAnimation(for: descripcionTextView)
        }
    }
    
    private func showErrorAnimation(for view: UIView) {
        UIView.animate(withDuration: 0.3) {
            view.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    private func setupVideoPlayer() {
        guard let videoPath = Bundle.main.path(forResource: "vd_Soporte", ofType: "mov") else { return }
        let videoURL = URL(fileURLWithPath: videoPath)
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        
        let videoWidth = view.frame.width * 0.7
        let videoHeight = videoWidth * 9 / 16
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = view.frame.height * 0.15 // Más arriba para que el form quede mejor
        
        playerLayer?.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        player?.play()
    }
    
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
}

