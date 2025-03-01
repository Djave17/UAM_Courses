//
//  PassViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 28/2/25.
//

import UIKit
import AVFoundation


class PassViewController: UIViewController {
  
    private let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
    // Reproductor de video
    var player: AVPlayer?
    
    @IBOutlet weak var txfActualPass: UITextField!
    
    @IBOutlet weak var txfNewPass: UITextField!
    
    
    @IBOutlet weak var txfEmail: UITextField!
    
    var playerLayer: AVPlayerLayer?
    
    //Outlet TextView
    
    @IBOutlet weak var txtvwDesc: UITextView!
    
    //Outlet Button
    
    @IBOutlet weak var btnChange: UIButton!
    
    var isFromLogin: Bool = false  // Para saber si venimos del LoginViewController o SettingsViewController

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isFromLogin {
            self.navigationItem.hidesBackButton = true  // Ocultar el botón de retroceso si venimos de LoginViewController
        } else {
            self.navigationItem.hidesBackButton = false  // Mostrar el botón de retroceso si venimos de SettingsViewController
        }
        
        txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        
        // Configuración del icono de sobre para el email
        let emailIcon = UIImageView(image: UIImage(systemName: "envelope"))
        emailIcon.tintColor = .systemTeal
        emailIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: txfEmail.frame.height))
        emailIcon.frame = CGRect(x: 10, y: (leftPaddingView.frame.height - 20) / 2, width: 20, height: 20)
        leftPaddingView.addSubview(emailIcon)
        
        txfEmail.leftView = leftPaddingView
        txfEmail.leftViewMode = .always
        

        // Configuración del icono de candado para el password
        let lockIcon = UIImageView(image: UIImage(systemName: "lock"))
        lockIcon.tintColor = .systemTeal
        lockIcon.contentMode = .scaleAspectFit
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: txfNewPass.frame.height))
        lockIcon.frame = CGRect(x: 10, y: (paddingView.frame.height - 20) / 2, width: 20, height: 20)
        paddingView.addSubview(lockIcon)
        
        txfNewPass.leftView = paddingView
        txfNewPass.leftViewMode = .always
        
        // Configuración del icono de candado para el password
        let lock = UIImageView(image: UIImage(systemName: "lock"))
        lock.tintColor = .systemTeal
        lock.contentMode = .scaleAspectFit

        
        // Configuración de bordes para las textFields
        txfEmail.layer.borderWidth = 1
        txfEmail.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        txfEmail.layer.cornerRadius = 5
        // Eventos de edición
        txfEmail.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        txfEmail.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        
        // Configuración de bordes para las textFields
        txfActualPass.layer.borderWidth = 1
        txfActualPass.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        txfActualPass.layer.cornerRadius = 5
        // Eventos de edición
        txfActualPass.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        txfActualPass.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        // Configuración de bordes para las textFields
        txfNewPass.layer.borderWidth = 1
        txfNewPass.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        txfNewPass.layer.cornerRadius = 5
        // Eventos de edición
        txfNewPass.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        txfNewPass.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        // Ajuste de padding para el icono
        let paddngView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: txfActualPass.frame.height))

        // Establecemos el tamaño y posición del icono dentro de la vista de padding
        lock.frame = CGRect(x: (paddngView.frame.width - 20) / 2, y: (paddngView.frame.height - 20) / 2, width: 20, height: 20)

        // Añadimos el icono a la vista de padding
        paddngView.addSubview(lock)

        // Asignamos la vista de padding como vista izquierda del UITextField
        txfActualPass.leftView = paddngView
        txfActualPass.leftViewMode = .always
        
        
        
        // LLamo la funcion de configuracion del vd
        setupVideoPlayer()

        // Desactivando interacción con Text View Descripcion
        //txtvwDesc.isScrollEnabled = false
        //txtvwDesc.isEditable = false
       // txtvwDesc.isSelectable = false
        
        //Custom Button
        btnChange.layer.cornerRadius = 10
        
        //Custom Button Back
        // Establecer el título en la barra de navegación
            self.title = "Cambiar Contraseña"
            
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
    
    private func setupVideoPlayer() {
        // Ruta del video en el bundle
        guard let videoPath = Bundle.main.path(forResource: "vd_Password", ofType: "mov") else {
            print("Error: No se encontró el video vd_Password.mov en el bundle.")
            return
        }
        
        // Crear la URL del video
        let videoURL = URL(fileURLWithPath: videoPath)
        
        // Crear el reproductor
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none // Evitar detener el video al terminar
        
        // Inicializar el playerLayer antes de usarlo
        playerLayer = AVPlayerLayer(player: player)
        
        // Tamaño ajustado - ancho + altura
        let videoWidth = view.frame.width * 0.3
        let videoHeight = videoWidth * 12 / 9
        
        // centro arriba video
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = view.frame.height * 0.15 // más arriba
        
        playerLayer?.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        playerLayer?.videoGravity = .resizeAspectFill
        
        // video subcapa
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        
        // bucle cuando termina el video
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        // Reproducir automáticamente
        player?.play()
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        // Validar si los TextFields están vacíos
           if txfActualPass.text?.isEmpty ?? true || txfNewPass.text?.isEmpty ?? true || txfEmail.text?.isEmpty ?? true{
               // Mostrar un mensaje si algún campo está vacío
               showAlert(title: "Error", message: "Por favor, complete todos los campos.")
               
               // Marcar los campos vacíos en rojo
               if txfActualPass.text?.isEmpty ?? true {
                   showErrorAnimation(for: txfActualPass)
               }
               
               if txfNewPass.text?.isEmpty ?? true {
                   showErrorAnimation(for: txfNewPass)
               }
               
               
               if txfEmail.text?.isEmpty ?? true {
                   showErrorAnimation(for: txfEmail)
               }
               return
           }
           
           // Si ambos campos están llenos, permitir pasar a la siguiente vista o acción
           // Aquí va tu lógica de cambio de contraseña
           let alert = UIAlertController(title: "¡Éxito!", message: "Contraseña Modificada", preferredStyle: .alert)

           // Color personalizado para el borde y texto
           let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)

           // Personalizar el título
           let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                            NSAttributedString.Key.foregroundColor: customColor]
           let attributedTitle = NSAttributedString(string: "¡Éxito!", attributes: titleFont)
           alert.setValue(attributedTitle, forKey: "attributedTitle")

           // Personalizar el mensaje
           let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                              NSAttributedString.Key.foregroundColor: customColor]
           let attributedMessage = NSAttributedString(string: "Contraseña Modificada", attributes: messageFont)
           alert.setValue(attributedMessage, forKey: "attributedMessage")

           // Botón "OK" con color personalizado
           let okAction = UIAlertAction(title: "OK", style: .default) { _ in
               self.irALoginViewController()
           }
           alert.addAction(okAction)

           // Cambiar el color del texto del botón
           okAction.setValue(customColor, forKey: "titleTextColor")

           DispatchQueue.main.async {
               if let topVC = UIApplication.shared.connectedScenes
                   .compactMap({ $0 as? UIWindowScene })
                   .flatMap({ $0.windows })
                   .first(where: { $0.isKeyWindow })?.rootViewController {

                   // Aplicar borde personalizado a la alerta
                   if let alertView = alert.view.subviews.first?.subviews.first?.subviews.first {
                       alertView.layer.cornerRadius = 10
                       alertView.layer.borderWidth = 2
                       alertView.layer.borderColor = customColor.cgColor
                   }

                   topVC.present(alert, animated: true, completion: nil)
               }
           }
       }

       // Función para mostrar la alerta personalizada
       private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

           // Color personalizado para el borde y texto
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
           let okAction = UIAlertAction(title: "OK", style: .default)
           alert.addAction(okAction)

           // Cambiar el color del texto del botón
           okAction.setValue(customColor, forKey: "titleTextColor")

           DispatchQueue.main.async {
               if let topVC = UIApplication.shared.connectedScenes
                   .compactMap({ $0 as? UIWindowScene })
                   .flatMap({ $0.windows })
                   .first(where: { $0.isKeyWindow })?.rootViewController {

                   // Aplicar borde personalizado a la alerta
                   if let alertView = alert.view.subviews.first?.subviews.first?.subviews.first {
                       alertView.layer.cornerRadius = 10
                       alertView.layer.borderWidth = 2
                       alertView.layer.borderColor = customColor.cgColor
                   }

                   topVC.present(alert, animated: true, completion: nil)
               }
           }
       }

       // Función para mostrar la animación de error (bordes rojos)
       private func showErrorAnimation(for textField: UITextField) {
           UIView.animate(withDuration: 0.3) {
               textField.layer.borderColor = UIColor.red.cgColor
           }
       }
    
    func irALoginViewController() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
         loginVC.modalPresentationStyle = .fullScreen
         
         DispatchQueue.main.async {
             if let topVC = UIApplication.shared.connectedScenes
                 .compactMap({ $0 as? UIWindowScene })
                 .flatMap({ $0.windows })
                 .first(where: { $0.isKeyWindow })?.rootViewController {
                 
                 topVC.present(loginVC, animated: true, completion: nil)
             }
         }
    }
    
    
    // Reiniciar el video cuando termine
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    deinit {
        // Eliminar el observador para evitar problemas de memoria
        NotificationCenter.default.removeObserver(self)
    }
    
}
