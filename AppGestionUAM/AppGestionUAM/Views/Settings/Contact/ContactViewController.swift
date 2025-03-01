import UIKit
import AVFoundation

class ContactViewController: UIViewController {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    private let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        self.title = "Soporte Técnico"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: customColor] // Título en color teal
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: customColor] // Botón Back en color teal
        navigationController?.navigationBar.tintColor = customColor // Flecha del botón Back en color teal
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Mensaje superior centrado
        let headerLabel = UILabel()
        headerLabel.text = "Envíanos un correo a Soporte Técnico"
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = customColor
        headerLabel.textAlignment = .center

        // Función para crear etiquetas
        func createLabel(text: String) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textColor = customColor
            return label
        }

        // Función para crear TextField
        func createTextField() -> UITextField {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return textField
        }

        // Crear elementos
        let remitenteLabel = createLabel(text: "Remitente")
        let remitenteTextField = createTextField()

        let asuntoLabel = createLabel(text: "Asunto")
        let asuntoTextField = createTextField()

        let descripcionLabel = createLabel(text: "Descripción del Problema")
        let descripcionTextView = UITextView()
        descripcionTextView.font = UIFont.systemFont(ofSize: 16)
        descripcionTextView.layer.borderColor = UIColor.gray.cgColor
        descripcionTextView.layer.borderWidth = 0.5
        descripcionTextView.layer.cornerRadius = 5
        descripcionTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        let enviarButton = UIButton(type: .system)
        enviarButton.setTitle("Enviar", for: .normal)
        enviarButton.setTitleColor(.white, for: .normal)
        enviarButton.backgroundColor = customColor
        enviarButton.layer.cornerRadius = 10
        enviarButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        enviarButton.widthAnchor.constraint(equalToConstant: 60).isActive = true // Botón más pequeño

        // StackView para organizar todo verticalmente
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel, remitenteLabel, remitenteTextField,
            asuntoLabel, asuntoTextField,
            descripcionLabel, descripcionTextView,
            enviarButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Configurar restricciones
        if let playerLayerFrameMaxY = playerLayer?.frame.maxY {
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: playerLayerFrameMaxY + 40), // Desplazamos más abajo

                enviarButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
            ])
        } else {
            // Si playerLayer es nil, ajustamos el stackView sin dependencias de playerLayer
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20), // Ajuste básico

                enviarButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
            ])
        }
    }

    private func setupVideoPlayer() {
        guard let videoPath = Bundle.main.path(forResource: "vd_Soporte", ofType: "mov") else { return }
        let videoURL = URL(fileURLWithPath: videoPath)
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        
        let videoWidth = view.frame.width * 0.7
        let videoHeight = videoWidth * 9 / 16
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = view.frame.height * 0.15 // Más arriba para que el form quede mejor

        playerLayer?.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        player?.play()
    }

    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
}

