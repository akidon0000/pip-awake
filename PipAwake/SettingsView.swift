import SwiftUI

struct SettingsView: View {
    @Bindable var settings: AppSettings

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    heightRow
                    widthRow
                    Button("初期値に戻す") {
                        settings.resetSize()
                    }
                } header: {
                    Text("映像の大きさ")
                } footer: {
                    Text("横幅と高さの比率が PiP 窓の形になります。変更は次に開始したときから反映されます。")
                }
            }
            .navigationTitle("設定")
        }
    }

    private var heightRange: ClosedRange<Double> {
        Double(AppSettings.heightRange.lowerBound)...Double(AppSettings.heightRange.upperBound)
    }

    private var heightRow: some View {
        VStack(alignment: .leading) {
            LabeledContent("高さ", value: "\(settings.frameHeight) px")
            Slider(
                value: heightBinding,
                in: heightRange,
                step: 1
            )
            .accessibilityLabel("高さ")
            .accessibilityValue("\(settings.frameHeight) ピクセル")
        }
    }

    private var widthRow: some View {
        VStack(alignment: .leading) {
            LabeledContent("横幅", value: "\(settings.effectiveWidth) px")
            Slider(
                value: widthBinding,
                in: Double(settings.widthRange.lowerBound)...Double(settings.widthRange.upperBound),
                step: 1
            )
            .accessibilityLabel("横幅")
            .accessibilityValue("\(settings.effectiveWidth) ピクセル")
        }
    }

    private var heightBinding: Binding<Double> {
        Binding(
            get: { Double(settings.frameHeight) },
            set: { settings.frameHeight = Int($0.rounded()) }
        )
    }

    private var widthBinding: Binding<Double> {
        Binding(
            get: { Double(settings.effectiveWidth) },
            set: { settings.frameWidth = Int($0.rounded()) }
        )
    }
}
