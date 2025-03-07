//
//  PasswordViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 6/3/25.
//

import UIKit
import AVFoundation
class PasswordViewController: UIViewController {
    private let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
    var player: AVPlayer?
    private var cameFromSettings = false
    @IBOutlet weak var txfActualPass: UITextField!
    @IBOutlet weak var txfNewPass: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    var playerLayer: AVPlayerLayer?
    //Outlet TextView
    @IBOutlet weak var txtvwDesc: UITextView!
    //Outlet Button
    @IBOutlet weak var btnChange: UIButton!
    var isFromLogin: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        let emailIcon = UIImageView(image: UIImage(systemName: "envelope"))
        emailIcon.tintColor = .systemTeal
        emailIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: txfEmail.frame.height))
        emailIcon.frame = CGRect(x: 10, y: (leftPaddingView.frame.height - 20) / 2, width: 20, height: 20)
        leftPaddingView.addSubview(emailIcon)
        txfEmail.leftView = leftPaddingView
        txfEmail.leftViewMode = .always
        let lockIcon = UIImageView(image: UIImage(systemName: "lock"))
        lockIcon.tintColor = .systemTeal
        lockIcon.contentMode = .scaleAspectFit
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: txfNewPass.frame.height))
        lockIcon.frame = CGRect(x: 10, y: (paddingView.frame.height - 20) / 2, width: 20, height: 20)
        paddingView.addSubview(lockIcon)
        txfNewPass.leftView = paddingView
        txfNewPass.leftViewMode = .always
        let lock = UIImageView(image: UIImage(systemName: "lock"))
        lock.tintColor = .systemTeal
        lock.contentMode = .scaleAspectFit
        txfEmail.layer.borderWidth = 1
        txfEmail.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        txfEmail.layer.cornerRadius = 5
        // Eventos de edición
        txfEmail.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        txfEmail.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        txfActualPass.layer.borderWidth = 1
        txfActualPass.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        txfActualPass.layer.cornerRadius = 5
        txfActualPass.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        txfActualPass.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        txfNewPass.layer.borderWidth = 1
        txfNewPass.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        txfNewPass.layer.cornerRadius = 5
        txfNewPass.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        txfNewPass.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        let paddngView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: txfActualPass.frame.height))
        lock.frame = CGRect(x: (paddngView.frame.width - 20) / 2, y: (paddngView.frame.height - 20) / 2, width: 20, height: 20)
        paddngView.addSubview(lock)
        txfActualPass.leftView = paddngView
        txfActualPass.leftViewMode = .always
        setupVideoPlayer()
        btnChange.layer.cornerRadius = 10
        self.title = "Cambiar Contraseña"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        navigationController?.navigationBar.tintColor = .systemTeal
        navigationController?.navigationBar.standardAppearance = { let appearance = UINavigationBarAppearance(); appearance.configureWithOpaqueBackground(); appearance.backgroundColor = .systemBackground; return appearance }()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func nameTextFieldEditingDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
    @objc func nameTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text?.isEmpty ?? true {
            showErrorAnimation(for: sender)
        } else {
            UIView.animate(withDuration: 0.3) {
                sender.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if txfActualPass.text?.isEmpty ?? true {
            showErrorAnimation(for: txfActualPass)
        }
        if txfNewPass.text?.isEmpty ?? true {
            showErrorAnimation(for: txfNewPass)
        }
        if txfEmail.text?.isEmpty ?? true {
            showErrorAnimation(for: txfEmail)
        }
    }
    
    private func setupVideoPlayer() {
        guard let videoPath = Bundle.main.path(forResource: "vd_Password", ofType: "mov") else {
            print("Error: No se encontró el video vd_Password.mov en el bundle.")
            return
        }
        let videoURL = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        playerLayer = AVPlayerLayer(player: player)
        let videoWidth = view.frame.width * 0.3
        let videoHeight = videoWidth * 12 / 9
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = view.frame.height * 0.15
        playerLayer?.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player?.play()
    }
    
    @IBAction func btnOpenSettings(_ sender: Any) {
        self.cameFromSettings = true
        showAlertWithNavigation(message: "Configuración modificada con éxito.")
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
            if txfActualPass.text?.isEmpty ?? true || txfNewPass.text?.isEmpty ?? true || txfEmail.text?.isEmpty ?? true {
                let errorAlert = UIAlertController(title: "\n\nError", message: "Por favor, complete todos los campos.", preferredStyle: .alert)
                let errorImage = UIImage(systemName: "xmark.circle.fill")?
                    .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
                let imageView = UIImageView(image: errorImage)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                errorAlert.view.addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: errorAlert.view.centerXAnchor),
                    imageView.topAnchor.constraint(equalTo: errorAlert.view.topAnchor, constant: 15),
                    imageView.widthAnchor.constraint(equalToConstant: 40),
                    imageView.heightAnchor.constraint(equalToConstant: 40)
                ])
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
                okAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
                errorAlert.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(errorAlert, animated: true)
                }
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
            showAlertWithNavigation(message: "Contraseña modificada con éxito.")
            
            // Solo ir al login si no vino de settings
           
        }

    
    private func showAlertWithNavigation(message: String) {
        let alert = UIAlertController(title: "\n\nÉxito", message: message, preferredStyle: .alert)
        let checkImage = UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: checkImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        okAction.setValue(UIColor.systemTeal, forKey: "titleTextColor")
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                         NSAttributedString.Key.foregroundColor: customColor]
        let attributedTitle = NSAttributedString(string: title, attributes: titleFont)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                           NSAttributedString.Key.foregroundColor: customColor]
        let attributedMessage = NSAttributedString(string: message, attributes: messageFont)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        okAction.setValue(customColor, forKey: "titleTextColor")
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController {
                if let alertView = alert.view.subviews.first?.subviews.first?.subviews.first {
                    alertView.layer.cornerRadius = 10
                    alertView.layer.borderWidth = 2
                    alertView.layer.borderColor = customColor.cgColor
                }
                topVC.present(alert, animated: true, completion: nil)
            }
        }
    }
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
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
