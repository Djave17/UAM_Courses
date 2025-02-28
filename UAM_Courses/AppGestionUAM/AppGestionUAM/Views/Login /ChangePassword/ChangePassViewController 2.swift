//
//  ChangePassViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 11/1/25.
//

import UIKit
import AVFoundation

class ChangePassViewController2: UIViewController {
    
    // Reproductor de video
    var player: AVPlayer?

    var playerLayer: AVPlayerLayer?
    
    //Outlet TextView
    
    @IBOutlet weak var txtvwDesc: UITextView!
    
    //Outlet Button
    
    @IBOutlet weak var btnChange: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        // LLamo la funcion de configuracion del vd
        setupVideoPlayer()

        // Desactivando interacción con Text View Descripcion
        //txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        
        //Custom Button
        btnChange.layer.cornerRadius = 10
        
        // Ocultar botón Back
            self.navigationItem.hidesBackButton = true
        
        //Custom Button Back
        // Establecer el título en la barra de navegación
            self.title = "Cambiar Contraseña"
            
            // Configurar la apariencia de la barra de navegación
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            // Cambiar el color del título de la vista
            appearance.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
            
            // Aplicar la configuración a la barra de navegación
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
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
