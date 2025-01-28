//
//  Onboarding3ViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 13/1/25.
//

import UIKit
import AVFoundation

class Onboarding3ViewController: UIViewController {
    
    //Outlets botones
    @IBOutlet weak var btnSig: UIButton!
    
    //Outlets txtview
    @IBOutlet weak var txtvwDesc: UITextView!
    
    // Reproductor de video
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración del video
        setupVideoPlayer()
        
        //Borde Circular
        btnSig.layer.cornerRadius = 13.5
        
        // Desactivando interacción con Text View Descripcion
        txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        
        // Desactivando interacción con Text View Title
        txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        
        hideBackButton()
        
    }
    
    @IBAction func btnLogIn(_ sender: Any) {
        
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        let loginButton = RegisterViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
    
//    @IBAction func saltarButtonTapped(_ sender: Any) {
//        let loginButton = LoginViewController()
//        navigationController?.pushViewController(loginButton, animated: true)
//    }
    
    // MARK: - Configuration of Video
    
    // Configurar el reproductor de video
    private func setupVideoPlayer() {
        // Ruta del video en el bundle
        guard let videoPath = Bundle.main.path(forResource: "vd_Onb3", ofType: "mov") else {
            print("Error: No se encontró el video vd_Onb2.mov en el bundle.")
            return
        }
        
        // Crear la URL del video
        let videoURL = URL(fileURLWithPath: videoPath)
        
        // Crear el reproductor
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none // Evitar detener la reproducción al terminar
        
        // Crear un AVPlayerLayer para mostrar el video
        let playerLayer = AVPlayerLayer(player: player)
        
        // Tamaño ajustado (reducir ancho, aumentar altura)
        let videoWidth = view.frame.width * 0.4 // 30% del ancho de la pantalla
        let videoHeight = videoWidth * 12 / 9 // Relación ajustada (más alto)
        
        // Posicionar el video al centro pero más arriba
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = (view.frame.height - videoHeight) / 3 // Ajuste para que esté más arriba
        
        playerLayer.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        playerLayer.videoGravity = .resizeAspectFill
        
        // Añadir el video como subcapa
        view.layer.insertSublayer(playerLayer, at: 0)
        
        // Reiniciar el video cuando termine
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        // Reproducir automáticamente
        player?.play()
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
