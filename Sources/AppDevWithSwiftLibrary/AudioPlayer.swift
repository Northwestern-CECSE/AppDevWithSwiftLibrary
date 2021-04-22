import Foundation
import AVKit

class AudioPlayer {
    static let shared = AudioPlayer()
    var player: AVAudioPlayer?
    
    func play(name: String, type: String) {
        let sound = Bundle.main.path(forResource: name, ofType: type)
        if let sound = sound {
            do {
                self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                self.player?.play()
            } catch {
                print (error.localizedDescription)
            }
        } else {
            print("AudioPlayer Error: File to play not found.")
        }
    }
    func pause() {
        if let p = player {
            p.pause()
        } else {
            print("AudioPlayer Error: Player not initialized, cannot pause.")
        }
    }
    
    func stop() {
        if let p = player {
            p.stop()
        } else {
            print("AudioPlayer Error: Player not initialized, cannot stop.")
        }
    }
    func isPlaying() -> Bool {
        if let p = player {
            return p.isPlaying
        } else {
            print("AudioPlayer Error: Player not initialized, cannot check playing status.")
        }
        return false
    }
}
