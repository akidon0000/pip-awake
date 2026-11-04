import CoreVideo
import Foundation
import Testing

@testable import PipAwake

@MainActor
struct ClockFrameRendererTests {
    private let frame = ClockFrame(elapsed: 3725)

    @Test
    func rendersBGRAWithStandardSize() throws {
        let rendered = ClockFrameRenderer().render(frame, style: .standard)
        let buffer = try #require(rendered)
        #expect(CVPixelBufferGetWidth(buffer) == 640)
        #expect(CVPixelBufferGetHeight(buffer) == 50)
        #expect(CVPixelBufferGetPixelFormatType(buffer) == kCVPixelFormatType_32BGRA)
    }

    @Test
    func followsCustomWidthAndHeight() throws {
        let style = ClockFrameStyle(width: 320, height: 120)
        let rendered = ClockFrameRenderer().render(frame, style: style)
        let buffer = try #require(rendered)
        #expect(CVPixelBufferGetWidth(buffer) == 320)
        #expect(CVPixelBufferGetHeight(buffer) == 120)
    }

    @Test
    func rendersNarrowestWidthOf50() throws {
        let style = ClockFrameStyle(width: 50, height: 30)
        let rendered = ClockFrameRenderer().render(frame, style: style)
        let buffer = try #require(rendered)
        #expect(CVPixelBufferGetWidth(buffer) == 50)
        #expect(CVPixelBufferGetHeight(buffer) == 30)
    }

    @Test
    func drawsLightTextOnBlackBackground() throws {
        let rendered = ClockFrameRenderer().render(frame, style: .standard)
        let buffer = try #require(rendered)
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
        let base = try #require(CVPixelBufferGetBaseAddress(buffer))
        let byteCount = CVPixelBufferGetBytesPerRow(buffer) * CVPixelBufferGetHeight(buffer)
        let bytes = UnsafeBufferPointer(
            start: base.assumingMemoryBound(to: UInt8.self),
            count: byteCount
        )
        // 左上の画素は背景の黒（BGRA の B, G, R が 0）
        #expect(bytes[0] == 0 && bytes[1] == 0 && bytes[2] == 0)
        // 文字の分だけ明るい画素がある
        let brightBytes = bytes.reduce(into: 0) { count, byte in
            if byte > 200 {
                count += 1
            }
        }
        #expect(brightBytes > 1_000)
    }
}
