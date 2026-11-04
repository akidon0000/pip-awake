import Foundation
import Testing

@testable import PipAwake

struct ClockTextTests {
    private func tokyoCalendar() throws -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "Asia/Tokyo"))
        return calendar
    }

    @Test
    func timeIsZeroPadded24Hour() throws {
        let calendar = try tokyoCalendar()
        // 1970-01-01 04:05:07 UTC = 13:05:07 JST
        #expect(
            ClockText.time(Date(timeIntervalSince1970: 14_707), calendar: calendar) == "13:05:07")
        // 1970-01-01 00:00:00 UTC = 09:00:00 JST
        #expect(ClockText.time(Date(timeIntervalSince1970: 0), calendar: calendar) == "09:00:00")
    }

    @Test
    func subtitleShowsElapsedAndPower() {
        #expect(ClockText.subtitle(elapsed: 3725, isPluggedIn: true) == "経過 1:02:05 ・ 給電中")
        #expect(ClockText.subtitle(elapsed: 0, isPluggedIn: false) == "経過 0:00:00 ・ 未給電")
    }
}
