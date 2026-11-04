import SwiftUI

struct RootView: View {
    let settings: AppSettings
    let feeder: ClockSampleBufferFeeder
    let pip: PiPController
    let audio: AudioSessionController

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
    }
}
