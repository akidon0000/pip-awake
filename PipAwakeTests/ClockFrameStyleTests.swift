import CoreGraphics
import Testing

@testable import PipAwake

struct ClockFrameStyleTests {
    @Test
    func keepsFullSizeWhenTextFitsWidth() {
        let sizes = ClockFrameStyle.standard.textSizes
        #expect(sizes.elapsed == 50 * 0.68)
        #expect(sizes.status == 50 * 0.44)
    }

    @Test
    func shrinksBothTextsTogetherWhenWidthIsNarrow() {
        let style = ClockFrameStyle(width: 320, height: 150, showsPowerStatus: true)
        let sizes = style.textSizes
        #expect(sizes.elapsed < 150 * 0.68)
        #expect(sizes.status < 150 * 0.44)
        // 縮めた後も比率は保つ
        #expect(abs(sizes.elapsed / sizes.status - 0.68 / 0.44) < 0.001)
    }

    @Test
    func centersElapsedTextWithoutRoomForStatusNeeds() {
        let style = ClockFrameStyle(width: 1280, height: 30, showsPowerStatus: false)
        #expect(style.textSizes.elapsed == 30 * 0.68)
    }
}
