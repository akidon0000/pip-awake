import Foundation

enum ClockText {
    static func time(_ date: Date, calendar: Calendar = .current) -> String {
        let parts = calendar.dateComponents([.hour, .minute, .second], from: date)
        let hour = parts.hour ?? 0
        let minute = parts.minute ?? 0
        let second = parts.second ?? 0
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }

    static func subtitle(elapsed: TimeInterval, isPluggedIn: Bool) -> String {
        let power = isPluggedIn ? "給電中" : "未給電"
        return "経過 \(ElapsedFormatter.string(from: elapsed)) ・ \(power)"
    }
}
