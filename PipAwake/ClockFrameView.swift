import SwiftUI

/// PiP に流す 1 フレームの見た目。経過時間を左、給電状況を右に横一列で置く。
/// 文字の大きさは ClockFrameStyle.textSizes に従い、念のため縮小も許す
struct ClockFrameView: View {
    let frame: ClockFrame
    let style: ClockFrameStyle

    var body: some View {
        HStack {
            if style.showsPowerStatus {
                elapsedText
                Spacer()
                statusText
            } else {
                Spacer()
                elapsedText
                Spacer()
            }
        }
        .padding(.horizontal, ClockFrameStyle.horizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }

    private var elapsedText: some View {
        Text(ElapsedFormatter.string(from: frame.elapsed))
            .font(.system(size: style.textSizes.elapsed, weight: .semibold).monospacedDigit())
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.4)
    }

    private var statusText: some View {
        Text(frame.isPluggedIn ? "給電中" : "未給電")
            .font(.system(size: style.textSizes.status))
            .foregroundStyle(frame.isPluggedIn ? Color(white: 0.67) : .red)
            .lineLimit(1)
            .minimumScaleFactor(0.4)
    }
}
