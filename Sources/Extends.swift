import SwiftUI

extension Color {
    static let background = Color("Background Color")
    static let countdownBackground = Color("Countdown Background Color")
    static let countdownText = Color("Countdown Text Color")
    static let earlyWarning = Color("Early Warning Color")
    static let finalWarning = Color("Final Warning Color")
}


extension TimeInterval {
    var lengthString: String {
        let duration = Duration.seconds(Int64(self))
        return duration.formatted(.units(allowed: [.minutes, .seconds], width: .wide))
    }

    var remainingString: String {
        let seconds = Int64(max(0.0, rounded(.up)))
        let duration = Duration.seconds(seconds)
        
        if seconds >= 3600 {
            return duration.formatted(.time(pattern: .hourMinuteSecond))
        } else {
            return duration.formatted(.time(pattern: .minuteSecond))
        }
    }
}


extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    var timeString: String {
        Date.formatter.string(from: self)
    }
    
    func droppingSeconds() -> Date {
        let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: self)
        return Calendar.current.date(from: components) ?? self
    }
}


extension UserDefaults {
    func color(forKey defaultName: String) -> Color? {
        guard
            let colorData = data(forKey: defaultName),
            let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        else { return nil }
        
        return Color(uiColor)
    }
    
    func image(forKey defaultName: String) -> UIImage? {
        data(forKey: defaultName).flatMap(UIImage.init)
    }
    
    func set(_ value: Color?, forKey key: String) {
        if let value, let data = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(value), requiringSecureCoding: true) {
            setValue(data, forKey: key)
        } else {
            setValue(nil, forKey: key)
        }
    }
    
    func set(_ value: UIImage?, forKey key: String) {
        if let value {
            setValue(value.pngData(), forKey: key)
        } else {
            setValue(nil, forKey: key)
        }
    }
}


extension Array where Element == Countdown {
    init?(rawValue: String) {
        guard
            let data = rawValue.data(using: .utf8),
            let decoded = try? JSONDecoder().decode([Countdown].self, from: data)
        else { return nil }
        
        self = decoded
    }
    
    var rawValue: String {
        guard
            let data = try? JSONEncoder().encode(Counter.shared.queue),
            let string = String(data: data, encoding: .utf8)
        else { return "[]" }
        
        return string
    }
}
