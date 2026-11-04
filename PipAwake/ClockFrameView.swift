import SwiftUI

/// PiP に流す 1 フレームの見た目。経過時間を中央に置く。
/// 文字の大きさは ClockFrameStyle.elapsedFontSize に従い、念のため縮小も許す
struct ClockFrameView: View {
    let frame: ClockFrame
    let style: ClockFrameStyle

    var body: some View {
        Text(ElapsedFormatter.string(from: frame.elapsed))
            .font(.system(size: style.elapsedFontSize, weight: .semibold).monospacedDigit())
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.4)
            .padding(.horizontal, style.horizontalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }
}
