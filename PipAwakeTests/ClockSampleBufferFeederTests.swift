import Foundation
import Testing

@testable import PipAwake

@MainActor
struct ClockSampleBufferFeederTests {
    @Test
    func displaySleepIsPreventedOnlyWhileFeeding() {
        let feeder = ClockSampleBufferFeeder()
        #expect(!feeder.displayLayer.preventsDisplaySleepDuringVideoPlayback)

        feeder.start(startedAt: Date())
        #expect(feeder.displayLayer.preventsDisplaySleepDuringVideoPlayback)

        feeder.pause()
        #expect(!feeder.displayLayer.preventsDisplaySleepDuringVideoPlayback)

        feeder.resume()
        #expect(feeder.displayLayer.preventsDisplaySleepDuringVideoPlayback)

        feeder.stop()
        #expect(!feeder.displayLayer.preventsDisplaySleepDuringVideoPlayback)
    }
}
