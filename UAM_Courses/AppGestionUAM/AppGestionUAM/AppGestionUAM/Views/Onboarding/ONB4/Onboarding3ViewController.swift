import UIKit
import AVFoundation

class Onboarding3ViewController: UIViewController {
    
    // Outlets botones
    
    // Outlets txtview
    @IBOutlet weak var txtvwDesc: UITextView!
    
    // Crear un AVPlayerLayer para mostrar el video
    var playerLayer: AVPlayerLayer?
    
    // Reproductor de video
    var player: AVPlayer?
    
    // Barra de progreso circular
    let progressBar = CircularProgressBar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración del video
        setupVideoPlayer()
        
        
        //Desactivando interacción con Text View Descripción
        txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        
        hideBackButton()
        setupProgressBar() // Configurar la barra de progreso
        
        // Iniciar la barra de progreso en 66% y animarla a 100%
        progressBar.setProgress(0.75, animated: false) // Inicia en 66.66%
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressBar.setProgress(1.0, animated: true) // Avanza a 100%
        }
    }
    
    private func setupProgressBar() {
        let screenHeight = view.bounds.height
        let yOffset = screenHeight * 0.90 // más abajo
        
        progressBar.center = CGPoint(x: view.center.x, y: yOffset)
        view.addSubview(progressBar)
        
        // Crear y configurar el botón
        let button = UIButton(frame: progressBar.frame)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(navigateToRegister), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func navigateToRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
    @IBAction func skip(_ sender: Any) {
        let loginButton = RegisterViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopVideo() // Detener el video al salir de la vista
    }
    
    private func setupVideoPlayer() {
        // Ruta del video en el bundle
        guard let videoPath = Bundle.main.path(forResource: "vd_Onb3", ofType: "mov") else {
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
        let videoWidth = view.frame.width * 0.4
        let videoHeight = videoWidth * 12 / 9
        
        // Posicionar el video al centro pero más arriba
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = (view.frame.height - videoHeight) / 3
        
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
    
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    deinit {
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
