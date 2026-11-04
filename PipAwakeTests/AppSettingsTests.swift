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
    func usesStandardValuesWhenNothingIsSaved() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        #expect(settings.frameHeight == ClockFrameStyle.standard.height)
        #expect(settings.frameWidth == ClockFrameStyle.standard.width)
    }

    @Test
    func restoresChangedValuesOnNextLaunch() throws {
        let defaults = try makeDefaults()
        let first = AppSettings(defaults: defaults)
        first.frameHeight = 90
        first.frameWidth = 800

        let second = AppSettings(defaults: defaults)
        #expect(second.frameHeight == 90)
        #expect(second.frameWidth == 800)
    }

    @Test
    func clampsSavedValuesIntoAllowedRange() throws {
        let defaults = try makeDefaults()
        defaults.set(9_999, forKey: "frameHeight")
        defaults.set(1, forKey: "frameWidth")

        let settings = AppSettings(defaults: defaults)
        #expect(settings.frameHeight == AppSettings.heightRange.upperBound)
        #expect(settings.effectiveWidth == AppSettings.minimumWidth)
    }

    @Test
    func acceptsNarrowestWidthOf50() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        settings.frameWidth = 50

        #expect(settings.widthRange.lowerBound == 50)
        #expect(settings.effectiveWidth == 50)
        #expect(settings.frameStyle.width == 50)
    }

    @Test
    func resetSizeRestoresStandardSize() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        settings.frameHeight = 120
        settings.frameWidth = 1000

        settings.resetSize()
        #expect(settings.frameHeight == ClockFrameStyle.standard.height)
        #expect(settings.frameWidth == ClockFrameStyle.standard.width)
    }

    @Test
    func frameStyleReflectsCurrentValues() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        settings.frameWidth = 480
        settings.frameHeight = 60

        #expect(settings.frameStyle == ClockFrameStyle(width: 480, height: 60))
    }

    @Test
    func widthUpperBoundFollowsScreenWidth() throws {
        let settings = AppSettings(defaults: try makeDefaults())
        settings.screenWidthPixels = 1206
        #expect(settings.widthRange.upperBound == 1206)

        settings.frameWidth = 1500
        #expect(settings.effectiveWidth == 1206)
    }
}
