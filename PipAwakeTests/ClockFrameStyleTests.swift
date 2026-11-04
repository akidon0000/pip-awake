import Testing

@testable import PipAwake

struct ClockFrameStyleTests {
    @Test
    func keepsFullSizeWhenTextFitsWidth() {
        #expect(ClockFrameStyle.standard.elapsedFontSize == 50 * 0.68)
    }

    @Test
    func shrinksTextWhenWidthIsNarrow() {
        let style = ClockFrameStyle(width: 320, height: 150)
        #expect(style.elapsedFontSize < 150 * 0.68)
    }

    @Test
    func keepsFullSizeWhenWidthIsWide() {
        let style = ClockFrameStyle(width: 1280, height: 30)
        #expect(style.elapsedFontSize == 30 * 0.68)
    }
}
