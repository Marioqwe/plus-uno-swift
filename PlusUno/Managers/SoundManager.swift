/// Taken from:
/// https://stackoverflow.com/questions/32036146/how-to-play-a-sound-using-swift
///
/// Thank you Devapploper!

import Foundation
import AVFoundation
import AudioToolbox

struct SoundManager {
    
    static fileprivate var player: AVAudioPlayer?
    static fileprivate var ambientPlayer: AVAudioPlayer?
    
    static func vibrate() {
        guard SessionManager.shared.vibrationSettingsState() != true else { return }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    static func playSound(name: String, isAmbient ambient: Bool = false) {
        guard SessionManager.shared.soundSettingsState() != true else { return }
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else { return }
        
        do {
            let category = ambient ? AVAudioSessionCategoryAmbient : AVAudioSessionCategoryPlayback
            try AVAudioSession.sharedInstance().setCategory(category)
            try AVAudioSession.sharedInstance().setActive(true)
            if ambient {
                ambientPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                ambientPlayer?.numberOfLoops = -1
                guard let player = ambientPlayer else { return }
                player.play()
            } else {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = player else { return }
                player.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func pauseAllSounds() {
        ambientPlayer?.pause()
    }
    
    static func resumeAllSounds() {
        ambientPlayer?.play()
    }
    
}
