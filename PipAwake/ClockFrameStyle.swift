import CoreGraphics

/// 映像の見た目の設定。横幅と高さの比率が PiP 窓の形になる（ピクセル単位）
struct ClockFrameStyle: Equatable {
    static let standard = ClockFrameStyle(width: 640, height: 50)

    var width: Int
    var height: Int

    /// 左右の余白。細い映像では余白を詰めて、文字の場所を残す
    var horizontalPadding: CGFloat {
        min(24, CGFloat(width) * 0.1)
    }

    /// 経過時間の文字の大きさ。高さに比例させ、横幅に入らないときは縮める
    var elapsedFontSize: CGFloat {
        let size = CGFloat(height) * 0.68
        // 文字幅は大まかな見積もり（数字は約 0.6em、「H:MM:SS」は約 3.6em）
        let neededWidth = size * 3.6
        let availableWidth = max(CGFloat(width) - horizontalPadding * 2, 1)
        return size * min(1, availableWidth / neededWidth)
    }
}
