import AVFoundation

@MainActor
protocol AudioSessionControlling: AnyObject {
    func activate() throws
    func deactivate()
}

@MainActor
final class AudioSessionController: AudioSessionControlling {
    func activate() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
        try session.setActive(true)
    }

    func deactivate() {
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(false, options: [.notifyOthersOnDeactivation])
    }
}
