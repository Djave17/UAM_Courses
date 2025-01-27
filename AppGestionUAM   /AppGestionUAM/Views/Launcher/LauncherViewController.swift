import UIKit
import AVFoundation // AVFoundation para poder usar AVAudioPlayer

class LauncherViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var rotatingImageView: UIImageView!
    
    // Reproductor de audio
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarAnimación()
        rotateImage() // Comienza la rotación
        AudioManager.shared.playSound(resourceName: "agua", fileExtension: "mp3") // Reproduce el sonido
        navigateToOnboarding() // Navega a la siguiente vista después de 6 segundos
                                // Reproduce el sonido
        hideBackButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pausar el audio al salir
        AudioManager.shared.pauseSound()
        
        audioPlayer?.pause()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reanudar el audio al volver
        audioPlayer?.play()
    }
    
    func playSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)

            if let soundURL = Bundle.main.url(forResource: "agua", withExtension: "mp3") {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } else {
                print("Archivo de sonido no encontrado en el bundle.")
            }
        } catch {
            print("Error al configurar o reproducir el sonido: \(error.localizedDescription)")
        }
    }

    func rotateImage() {
        // Realiza una rotación completa de 360 grados en 2 segundos
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        // Duración de una vuelta completa
        rotationAnimation.duration = 2.0
        // Bucle infinito
        rotationAnimation.repeatCount = .infinity
        // Animación de Giro
        rotatingImageView.layer.add(rotationAnimation, forKey: "rotateAnimation")
    }
    
    func navigateToOnboarding() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // Carga la vista de Onboarding1 desde un archivo XIB
            let onboarding1 = Onboarding1ViewController()
            self.navigationController?.pushViewController(onboarding1, animated: true)
        }
    }
    
    func mostrarAnimación(){
        let fadeView = UIView(frame: self.view.bounds)
        fadeView.backgroundColor = UIColor.white
        self.view.addSubview(fadeView)
        
        UIView.animate(withDuration: 1.0, animations: {
            fadeView.alpha = 0
        }) { _ in
            fadeView.removeFromSuperview()
        }
    }
    
}

