import Foundation
import Testing

@testable import PipAwake

@MainActor
struct AppSettingsTests {
    /// テストごとに別の保存先を使い、実際の設定を汚さない
    private func makeDefaults() throws -> UserDefaults {
        let name = "AppSettingsTests-\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: name))
        defaults.removePersistentDomain(forName: name)
        return defaults
    }

    @Test
    func usesStandardSizeWhenNothingIsSaved() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        #expect(settings.frameHeight == ClockFrameStyle.standard.height)
        #expect(settings.frameWidth == ClockFrameStyle.standard.width)
    }

    @Test
    func restoresChangedValuesOnNextLaunch() throws {
        let defaults = try makeDefaults()
        let first = AppSettings(defaults: defaults)
        first.frameHeight = 90
        first.frameRatio = 4.5

        let second = AppSettings(defaults: defaults)
        #expect(second.frameHeight == 90)
        #expect(second.frameRatio == 4.5)
    }

    @Test
    func clampsSavedValuesIntoAllowedRange() throws {
        let defaults = try makeDefaults()
        defaults.set(9_999, forKey: "frameHeight")
        defaults.set(0.1, forKey: "frameRatio")

        let settings = AppSettings(defaults: defaults)
        #expect(settings.frameHeight == AppSettings.heightRange.upperBound)
        #expect(settings.frameRatio == AppSettings.ratioRange.lowerBound)
    }

    @Test
    func resetSizeRestoresStandardSize() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        settings.frameHeight = 120
        settings.frameRatio = 3

        settings.resetSize()
        #expect(settings.frameHeight == ClockFrameStyle.standard.height)
        #expect(settings.frameWidth == ClockFrameStyle.standard.width)
    }

    @Test
    func widthIsDerivedFromHeightAndRatio() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        settings.frameHeight = 60
        settings.frameRatio = 8

        #expect(settings.frameWidth == 480)
        #expect(settings.frameStyle == ClockFrameStyle(width: 480, height: 60))
    }

    @Test
    func squareRatioGivesSameWidthAndHeight() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        settings.frameHeight = 30
        settings.frameRatio = 1

        #expect(settings.frameStyle == ClockFrameStyle(width: 30, height: 30))
    }
}
