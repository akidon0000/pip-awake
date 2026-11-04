import SwiftUI

struct SettingsView: View {
    @Bindable var settings: AppSettings

    var body: some View {
        NavigationStack {
            Form {
                sizeSection
            }
            .navigationTitle("設定")
        }
    }

    private var sizeSection: some View {
        Section {
            Stepper(
                value: $settings.frameHeight,
                in: AppSettings.heightRange,
                step: AppSettings.heightStep
            ) {
                LabeledContent("高さ", value: "\(settings.frameHeight) px")
            }
            Stepper(
                value: $settings.frameWidth,
                in: AppSettings.widthRange,
                step: AppSettings.widthStep
            ) {
                LabeledContent("横幅", value: "\(settings.frameWidth) px")
            }
            Button("初期値に戻す") {
                settings.resetSize()
            }
        } header: {
            Text("映像の大きさ")
        } footer: {
            Text("横幅と高さの比率が PiP 窓の形になります。変更は次に開始したときから反映されます。")
        }
    }
}
