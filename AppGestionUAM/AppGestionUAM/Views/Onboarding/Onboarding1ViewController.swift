import UIKit
import AVKit
import AVFoundation

class Onboarding1ViewController: UIViewController {
    
    // Reproductor de video
    var player: AVPlayer?
    
    //Outlets txtView
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var txtvwOb1: UITextView!
    @IBOutlet weak var txtvwTitle: UITextView!
    
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Desactivando interacción con Text View Descripcion
        txtvwOb1.isScrollEnabled = false
        txtvwOb1.isEditable = false
        txtvwOb1.isSelectable = false
        
        // Desactivando interacción con Text View Title
        txtvwTitle.isScrollEnabled = false
        txtvwTitle.isEditable = false
        txtvwTitle.isSelectable = false
        
        continueButton.layer.cornerRadius = 30
        continueButton.clipsToBounds = true
        
        // Configuración del video
        setupVideoPlayer()
        hideBackButton()
    }
    
    
    // Navegación
    @IBAction func nav(_ sender: Any) {
        let onboarding2 = Onboarding2ViewController()
        onboarding2.navigationItem.hidesBackButton = true // Oculta el botón de "Back"
        navigationController?.pushViewController(onboarding2, animated: true)
    }
    
    
    @IBAction func saltarTapped(_ sender: Any) {
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopVideo() // Detener el video al salir de la vista
    }
    
    
    
    private func setupVideoPlayer() {
        // Ruta del video en el bundle
        guard let videoPath = Bundle.main.path(forResource: "vd_Onb1", ofType: "mov") else {
            print("Error: No se encontró el video vd_Onb3.mov en el bundle.")
            return
        }
        
        // Crear la URL del video
        let videoURL = URL(fileURLWithPath: videoPath)
        
        // Crear el reproductor
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none // Evitar detener la reproducción al terminar
        
        // Inicializar el playerLayer antes de usarlo
        playerLayer = AVPlayerLayer(player: player)
        
        // Tamaño ajustado (reducir ancho, aumentar altura)
        let videoWidth = view.frame.width * 0.4 // 40% del ancho de la pantalla
        let videoHeight = videoWidth * 12 / 9   // Relación ajustada (más alto)
        
        // Posicionar el video al centro pero más arriba
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = (view.frame.height - videoHeight) / 3 // Ajuste para que esté más arriba
        
        playerLayer?.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        playerLayer?.videoGravity = .resizeAspectFill
        
        // Añadir el video como subcapa
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        
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
    func stopVideo() {
        player?.pause()
        player?.replaceCurrentItem(with: nil) // Libera el video cargado
        playerLayer?.removeFromSuperlayer() // Elimina el layer del video
        
        // Asigna nil para liberar memoria
        player = nil
        playerLayer = nil
    }
}
