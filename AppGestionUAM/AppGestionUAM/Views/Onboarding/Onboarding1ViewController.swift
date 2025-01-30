import UIKit
import AVKit
import AVFoundation

class Onboarding1ViewController: UIViewController {
    
    // Reproductor de video
    var player: AVPlayer?
    
    // Outlets txtView
    @IBOutlet weak var txtvwOb1: UITextView!
    @IBOutlet weak var txtvwTitle: UITextView!
    
    var playerLayer: AVPlayerLayer?
    
    let progressBar = CircularProgressBar(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) // Barra de progreso
    
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

        // Configuración del video
        setupVideoPlayer()
        hideBackButton()
        setupProgressBar() // Configuración de la barra de progreso
        
        // Iniciar la barra de progreso en 0 y luego animarla al 33.33%
        progressBar.setProgress(0, animated: false) // Inicia en 0%
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressBar.setProgress(0.3333, animated: true) // 33.33% de progreso
        }
    }
    
    // Configurar la barra de progreso circular
    private func setupProgressBar() {
        let screenHeight = view.bounds.height
        let yOffset = screenHeight * 0.90 // más abajo
        
        progressBar.center = CGPoint(x: view.center.x, y: yOffset)
        view.addSubview(progressBar)
        
        // Crear y configurar el botón
        let button = UIButton(frame: progressBar.frame)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(navigateToNextScreen), for: .touchUpInside)
        view.addSubview(button)
    }
    
    // Navegación programática
    @objc private func navigateToNextScreen() {
        let onboarding2 = Onboarding2ViewController()
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
            print("Error: No se encontró el video vd_Onb1.mov en el bundle.")
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
        let videoWidth = view.frame.width * 0.4
        let videoHeight = videoWidth * 12 / 9
        
        // centro arriba video
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = (view.frame.height - videoHeight) / 3 // más arriba
        
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
    
    func stopVideo() {
        player?.pause()
        player?.replaceCurrentItem(with: nil) // Libera el video cargado
        playerLayer?.removeFromSuperlayer() // Elimina el layer del video
        
        // Asigna nil para liberar memoria
        player = nil
        playerLayer = nil
    }
}
