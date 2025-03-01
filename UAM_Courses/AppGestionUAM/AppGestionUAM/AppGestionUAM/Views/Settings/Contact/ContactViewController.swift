import UIKit
import AVFoundation

class ContactViewController: UIViewController {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoPlayer()
        
        self.title = "Soporte Técnico"
        
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
        
        // Custom Button
        btnSend.layer.cornerRadius = 10
    }
    
    private func setupVideoPlayer() {
        // Ruta del video en el bundle
        guard let videoPath = Bundle.main.path(forResource: "vd_Soporte", ofType: "mov") else {
            print("Error: No se encontró el video vd_Soporte.mov en el bundle.")
            return
        }
        
        // Crear la URL del video
        let videoURL = URL(fileURLWithPath: videoPath)
        
        // Crear el reproductor
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none // Evitar detener el video al terminar
        
        // Inicializar el playerLayer antes de usarlo
        playerLayer = AVPlayerLayer(player: player)
        
        // Ajustar el video para que se ajuste al ancho y alto de la pantalla sin recorte
        playerLayer?.videoGravity = .resizeAspect // Mantener la proporción sin recortar
        
        // Establecer el tamaño del video pequeño y más abajo
        let videoWidth = view.frame.width * 0.7  // 70% del ancho de la vista
        let videoHeight = videoWidth * 9 / 16  // Mantener proporción 16:9
        
        // Posicionar el video más abajo (incrementamos centerY)
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = view.frame.height * 0.2  // Ahora está un poco más abajo
        
        playerLayer?.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        
        // Insertar la capa de video en la vista
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        
        // Bucle cuando termina el video
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
