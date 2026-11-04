import CoreMedia
import Foundation
import Testing

@testable import PipAwake

struct SampleBufferFactoryTests {
    @Test
    func wrapsPixelBufferWithPresentationTime() throws {
        let frame = ClockFrame(elapsed: 0, isPluggedIn: true)
        let pixelBuffer = try #require(ClockFrameRenderer().render(frame))
        let time = CMTime(seconds: 42, preferredTimescale: 600)

        let sample = try #require(
            SampleBufferFactory.make(from: pixelBuffer, presentationTime: time))

        #expect(sample.presentationTimeStamp == time)
        #expect(sample.duration == CMTime(value: 1, timescale: 1))
        #expect(sample.imageBuffer === pixelBuffer)
    }
}
