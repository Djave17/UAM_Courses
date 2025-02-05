import UIKit
import AVFoundation // AVFoundation para poder usar AVAudioPlayer

class LauncherViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var image: UIImageView!
    
    //Outlets de labels
    @IBOutlet weak var lblCourses: UILabel!
    
    @IBOutlet weak var lblUAM: UILabel!
    
    // Reproductor de audio
    var audioPlayer: AVAudioPlayer?
    
    var apiClient = APIClient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = apiClient.getUserId()
        allFunc()
        let token = apiClient.getToken()
        
        if APIClient.shared.isUserLoggedIn() {
            // Navegar directamente a la pantalla principal
            print("Usuario autenticado \(String(describing: userID))")
            print("Navegando hacia courses - Token: \(String(describing: token))")
            navigateToCourses()
        } else {
            // Mostrar pantalla de login
            navigateToOnboarding()
           
        }
        
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
    
    func allFunc(){
        animateImagePulse()
        
        animateLabels()
        
        AudioManager.shared.playSound(resourceName: "agua", fileExtension: "mp3")
                                // Reproduce el sonido
        hideBackButton()
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
    
    func navigateToOnboarding() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            // Carga la vista de Onboarding1 desde un archivo XIB
            let onboarding1 = Onboarding1ViewController()
            self.navigationController?.pushViewController(onboarding1, animated: true)
        }
    }
    
    func navigateToCourses(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            let courseListViewController = CourseListViewController()
            self.navigationController?.pushViewController(courseListViewController, animated: true)
        }
    }
    
    //MARK: - Animations
    
    /*
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
    */
    
    
    /*
    func mostrarAnimación(){
        let fadeView = UIView(frame: self.view.bounds)
        fadeView.backgroundColor = UIColor.white
        self.view.addSubview(fadeView)
        
        UIView.animate(withDuration: 1.0, animations: {
            fadeView.alpha = 0
        }) { _ in
            fadeView.removeFromSuperview()
        }
     */
    
    func animateLabels() {
        // Animación para el label de Courses (desliza desde la izquierda a la derecha)
        lblUAM.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0) // Inicia fuera de la vista a la izquierda
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.lblUAM.transform = CGAffineTransform.identity // Vuelve a la posición original
        })
        
        // Animación para el label de UAM (desliza desde la derecha a la izquierda)
        lblCourses.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0) // Inicia fuera de la vista a la derecha
        UIView.animate(withDuration: 1.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.lblCourses.transform = CGAffineTransform.identity // Vuelve a la posición original
        })
    }
    
    func animateImagePulse() {
        // Primero, la imagen debe ser más pequeña para iniciar el pulso
        image.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // Escala inicial más pequeña
        
        // Animación para el "pulso" (crecer y encoger)
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.199, initialSpringVelocity: 1.1, options: [.autoreverse], animations: {
            self.image.transform = CGAffineTransform.identity // Escala normal
        })
    }
    
    }

