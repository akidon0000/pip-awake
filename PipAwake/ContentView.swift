import AVFoundation
import SwiftUI

struct ContentView: View {
    let feeder: ClockSampleBufferFeeder
    let pip: PiPController
    let audio: AudioSessionController
    @State private var isRunning = false

    var body: some View {
        VStack(spacing: 24) {
            SampleBufferLayerView(displayLayer: feeder.displayLayer)
                .aspectRatio(16.0 / 9.0, contentMode: .fit)
                .clipShape(.rect(cornerRadius: 12))
            Button(isRunning ? "停止" : "開始") {
                if isRunning {
                    stop()
                } else {
                    start()
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }

    private func start() {
        do {
            try audio.activate()
        } catch {
            return
        }
        feeder.start(startedAt: Date())
        pip.start()
        isRunning = true
    }

    private func stop() {
        pip.stop()
        feeder.stop()
        audio.deactivate()
        isRunning = false
    }
}
