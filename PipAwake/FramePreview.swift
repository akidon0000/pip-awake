import SwiftUI

/// 設定した大きさの映像を、実際に流す見た目のまま縮小して表示する
struct FramePreview: View {
    let style: ClockFrameStyle

    var body: some View {
        GeometryReader { proxy in
            let scale = proxy.size.width / CGFloat(style.width)
            ClockFrameView(frame: ClockFrame(elapsed: 3725), style: style)
                .frame(width: CGFloat(style.width), height: CGFloat(style.height))
                .scaleEffect(scale, anchor: .topLeading)
                .frame(
                    width: proxy.size.width, height: CGFloat(style.height) * scale,
                    alignment: .topLeading
                )
                .clipShape(.rect(cornerRadius: 12))
        }
        .aspectRatio(CGFloat(style.width) / CGFloat(style.height), contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}
