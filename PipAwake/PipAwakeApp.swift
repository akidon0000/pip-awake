import SwiftUI

@main
struct PipAwakeApp: App {
    private let settings = AppSettings()
    private let feeder = ClockSampleBufferFeeder()
    private let pip: PiPController
    private let audio = AudioSessionController()

    init() {
        pip = PiPController(displayLayer: feeder.displayLayer)
    }

    var body: some Scene {
        WindowGroup {
            RootView(settings: settings, feeder: feeder, pip: pip, audio: audio)
        }
    }
}
