import Foundation
import Testing

@testable import PipAwake

struct ElapsedFormatterTests {
    @Test(
        arguments: zip(
            [0, 59.9, 3725, 36_000, -5] as [TimeInterval],
            ["0:00:00", "0:00:59", "1:02:05", "10:00:00", "0:00:00"]
        )
    )
    func formatsAsHoursMinutesSeconds(seconds: TimeInterval, expected: String) {
        #expect(ElapsedFormatter.string(from: seconds) == expected)
    }
}
