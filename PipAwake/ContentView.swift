import AVFoundation
import SwiftUI

struct ContentView: View {
    let settings: AppSettings
    let feeder: ClockSampleBufferFeeder
    let pip: PiPController
    let audio: AudioSessionController
    @State private var isRunning = false
    /// 開始したときの設定。実行中は設定タブの変更を反映せず、この大きさで表示する
    @State private var runningStyle = ClockFrameStyle.standard

    var body: some View {
        VStack(spacing: 24) {
            SampleBufferLayerView(displayLayer: feeder.displayLayer)
                .aspectRatio(aspectRatio, contentMode: .fit)
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

    private var shownStyle: ClockFrameStyle {
        isRunning ? runningStyle : settings.frameStyle
    }

    private var aspectRatio: CGFloat {
        CGFloat(shownStyle.width) / CGFloat(shownStyle.height)
    }

    private func start() {
        do {
            try audio.activate()
        } catch {
            return
        }
        runningStyle = settings.frameStyle
        feeder.style = runningStyle
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
