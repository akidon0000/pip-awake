import Foundation
import Observation

/// 設定の値。UserDefaults に保存し、次に起動したときも同じ値を読む
@MainActor
@Observable
final class AppSettings {
    static let heightRange = 30...150
    /// 横幅 ÷ 高さ。1（正方形）から 16（横長）まで
    static let ratioRange = 1.0...16.0
    static let defaultRatio =
        Double(ClockFrameStyle.standard.width)
        / Double(ClockFrameStyle.standard.height)

    var frameHeight: Int {
        didSet { defaults.set(frameHeight, forKey: Key.frameHeight) }
    }

    /// 横幅 ÷ 高さ。PiP 窓の形はこの比率で決まる
    var frameRatio: Double {
        didSet { defaults.set(frameRatio, forKey: Key.frameRatio) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        frameHeight = Self.clamp(
            defaults.object(forKey: Key.frameHeight) as? Int ?? ClockFrameStyle.standard.height,
            to: Self.heightRange
        )
        frameRatio = Self.clamp(
            defaults.object(forKey: Key.frameRatio) as? Double ?? Self.defaultRatio,
            to: Self.ratioRange
        )
    }

    /// 横幅。高さと比率から決まる
    var frameWidth: Int {
        Int((Double(frameHeight) * frameRatio).rounded())
    }

    var frameStyle: ClockFrameStyle {
        ClockFrameStyle(width: frameWidth, height: frameHeight)
    }

    func resetSize() {
        frameHeight = ClockFrameStyle.standard.height
        frameRatio = Self.defaultRatio
    }

    private static func clamp<T: Comparable>(_ value: T, to range: ClosedRange<T>) -> T {
        min(max(value, range.lowerBound), range.upperBound)
    }

    private enum Key {
        static let frameHeight = "frameHeight"
        static let frameRatio = "frameRatio"
    }
}
