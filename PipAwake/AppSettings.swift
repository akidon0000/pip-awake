import Foundation
import Observation

/// 設定の値。UserDefaults に保存し、次に起動したときも同じ値を読む
@MainActor
@Observable
final class AppSettings {
    static let heightRange = 30...150
    static let widthRange = 320...1280
    static let heightStep = 5
    static let widthStep = 20

    var frameHeight: Int {
        didSet { defaults.set(frameHeight, forKey: Key.frameHeight) }
    }

    var frameWidth: Int {
        didSet { defaults.set(frameWidth, forKey: Key.frameWidth) }
    }

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
            to: Self.widthRange
        )
    }

    var frameStyle: ClockFrameStyle {
        ClockFrameStyle(width: frameWidth, height: frameHeight)
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
