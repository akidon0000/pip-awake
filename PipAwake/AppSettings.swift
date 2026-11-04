import Foundation
import Observation

/// 設定の値。UserDefaults に保存し、次に起動したときも同じ値を読む
@MainActor
@Observable
final class AppSettings {
    static let heightRange = 30...150
    static let minimumWidth = 50
    /// 画面の横幅がまだ分からないときに使う、横幅の上限
    static let fallbackMaximumWidth = 1280

    var frameHeight: Int {
        didSet { defaults.set(frameHeight, forKey: Key.frameHeight) }
    }

    var frameWidth: Int {
        didSet { defaults.set(frameWidth, forKey: Key.frameWidth) }
    }

    /// 画面の横幅（ピクセル）。RootView が起動後に測って入れる。保存はしない
    var screenWidthPixels = AppSettings.fallbackMaximumWidth

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let standard = ClockFrameStyle.standard
        frameHeight = Self.clamp(
            defaults.object(forKey: Key.frameHeight) as? Int ?? standard.height,
            to: Self.heightRange
        )
        frameWidth = Self.clamp(
            defaults.object(forKey: Key.frameWidth) as? Int ?? standard.width,
            to: Self.minimumWidth...Self.fallbackMaximumWidth
        )
    }

    /// 横幅を選べる範囲。下限は 50px、上限は画面の横幅
    var widthRange: ClosedRange<Int> {
        Self.minimumWidth...max(Self.minimumWidth, screenWidthPixels)
    }

    /// 実際に使う横幅
    var effectiveWidth: Int {
        Self.clamp(frameWidth, to: widthRange)
    }

    var frameStyle: ClockFrameStyle {
        ClockFrameStyle(width: effectiveWidth, height: frameHeight)
    }

    func resetSize() {
        frameWidth = ClockFrameStyle.standard.width
        frameHeight = ClockFrameStyle.standard.height
    }

    private static func clamp(_ value: Int, to range: ClosedRange<Int>) -> Int {
        min(max(value, range.lowerBound), range.upperBound)
    }

    private enum Key {
        static let frameHeight = "frameHeight"
        static let frameWidth = "frameWidth"
    }
}
