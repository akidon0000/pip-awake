import SwiftUI

/// PiP に流す 1 フレームの見た目。経過時間を左、給電状況を右に横一列で置く
struct ClockFrameView: View {
    let frame: ClockFrame

    var body: some View {
        HStack {
            Text(ElapsedFormatter.string(from: frame.elapsed))
                .font(.system(size: 34, weight: .semibold).monospacedDigit())
                .foregroundStyle(.white)
            Spacer()
            Text(frame.isPluggedIn ? "給電中" : "未給電")
                .font(.system(size: 22))
                .foregroundStyle(frame.isPluggedIn ? Color(white: 0.67) : .red)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
