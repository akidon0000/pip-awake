import SwiftUI

struct RootView: View {
    let settings: AppSettings
    let feeder: ClockSampleBufferFeeder
    let pip: PiPController
    let audio: AudioSessionController
    @Environment(\.displayScale)
    private var displayScale

    var body: some View {
        TabView {
            ContentView(settings: settings, feeder: feeder, pip: pip, audio: audio)
                .tabItem {
                    Label("表示", systemImage: "timer")
                }
            SettingsView(settings: settings)
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
        }
        .background {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        updateScreenWidth(proxy.size.width)
                    }
                    .onChange(of: proxy.size.width) { _, width in
                        updateScreenWidth(width)
                    }
            }
        }
    }

    /// 縦向きだけで使うので、画面の幅は見えている領域の幅と同じ
    private func updateScreenWidth(_ points: CGFloat) {
        settings.screenWidthPixels = Int((points * displayScale).rounded())
    }
}
