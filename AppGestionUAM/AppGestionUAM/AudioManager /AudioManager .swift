//
//  AudioManager .swift
//  AppGestionUAM
//
//  Created by David Sanchez on 26/1/25.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    // Reproducir sonido
    func playSound(resourceName: String, fileExtension: String) {
        guard let soundURL = Bundle.main.url(forResource: resourceName, withExtension: fileExtension) else {
            print("Archivo de sonido no encontrado")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // Repetir indefinidamente
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error al reproducir el sonido: \(error.localizedDescription)")
        }
    }

    // Pausar el sonido
    func pauseSound() {
        audioPlayer?.pause()
    }

    // Detener el sonido
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    
}



