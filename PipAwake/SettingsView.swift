import SwiftUI

struct SettingsView: View {
    @Bindable var settings: AppSettings

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    FramePreview(style: settings.frameStyle)
                } header: {
                    Text("プレビュー")
                } footer: {
                    Text("実際の映像と同じ比率で表示しています。")
                }

                Section {
                    heightRow
                    ratioRow
                    LabeledContent(
                        "映像の大きさ",
                        value: "\(settings.frameWidth) × \(settings.frameHeight) px"
                    )
                    Button("初期値に戻す") {
                        settings.resetSize()
                    }
                } header: {
                    Text("映像の大きさ")
                } footer: {
                    Text("比率は横幅 ÷ 高さです。PiP 窓の形は比率で決まります。変更は次に開始したときから反映されます。")
                }
            }
            .navigationTitle("設定")
        }
    }

    private var heightRange: ClosedRange<Double> {
        Double(AppSettings.heightRange.lowerBound)...Double(AppSettings.heightRange.upperBound)
    }

    private var heightBinding: Binding<Double> {
        Binding(
            get: { Double(settings.frameHeight) },
            set: { settings.frameHeight = Int($0.rounded()) }
        )
    }

    private var heightRow: some View {
        VStack(alignment: .leading) {
            LabeledContent("高さ", value: "\(settings.frameHeight) px")
            Slider(value: heightBinding, in: heightRange, step: 1)
                .accessibilityLabel("高さ")
                .accessibilityValue("\(settings.frameHeight) ピクセル")
        }
    }

    private var ratioRow: some View {
        let ratioText = settings.frameRatio.formatted(.number.precision(.fractionLength(1)))
        return VStack(alignment: .leading) {
            LabeledContent("横幅の比率", value: "\(ratioText) : 1")
            Slider(value: $settings.frameRatio, in: AppSettings.ratioRange, step: 0.1)
                .accessibilityLabel("横幅の比率")
                .accessibilityValue("\(ratioText) 対 1")
        }
    }
}
