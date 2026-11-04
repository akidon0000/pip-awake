import CoreGraphics

/// 映像の見た目の設定。横幅と高さの比率が PiP 窓の形になる（ピクセル単位）
struct ClockFrameStyle: Equatable {
    static let standard = ClockFrameStyle(width: 640, height: 50, showsPowerStatus: true)
    static let horizontalPadding: CGFloat = 24

    var width: Int
    var height: Int
    var showsPowerStatus: Bool

    /// 経過時間と給電状況の文字の大きさ。高さに比例させ、横幅に入らないときは両方を同じ比率で縮める
    var textSizes: (elapsed: CGFloat, status: CGFloat) {
        let height = CGFloat(height)
        let elapsed = height * 0.68
        let status = height * 0.44
        // 文字幅は大まかな見積もり（数字は約 0.6em、「給電中」は 3 文字分）
        let statusWidth = showsPowerStatus ? status * 3.0 : 0
        let gap: CGFloat = showsPowerStatus ? 16 : 0
        let neededWidth = elapsed * 3.6 + statusWidth + gap
        let availableWidth = CGFloat(width) - Self.horizontalPadding * 2
        let scale = min(1, availableWidth / neededWidth)
        return (elapsed * scale, status * scale)
    }
}
