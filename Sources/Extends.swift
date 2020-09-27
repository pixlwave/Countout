import SwiftUI

extension Color {
    static let background = Color("Background Color")
    static let countdownBackground = Color("Countdown Background Color")
    static let countdownText = Color("Countdown Text Color")
    static let earlyWarning = Color("Early Warning Color")
    static let finalWarning = Color("Final Warning Color")
}


extension TimeInterval {
    static let lengthFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    
    var lengthString: String {
        return TimeInterval.lengthFormatter.string(from: self) ?? ""
    }
    
    static let remainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
    static let remainingSecondsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    var remainingString: String {
        let seconds = Int(max(0.0, self.rounded(.up)))
        
        var components = DateComponents()
        components.second = seconds
        
        if seconds > 60 {
            return TimeInterval.remainingFormatter.string(from: components) ?? ""
        } else {
            return String(TimeInterval.remainingSecondsFormatter.string(from: components)?.dropFirst() ?? Substring(""))
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
        if let imageData = data(forKey: defaultName) {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
    
    func cgFloat(forKey defaultName: String) -> CGFloat? {
        return object(forKey: defaultName) as? CGFloat
    }
    
    func set(_ value: Color?, forKey key: String) {
        if let value = value, let data = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(value), requiringSecureCoding: true) {
            setValue(data, forKey: key)
        } else {
            setValue(nil, forKey: key)
        }
    }
    
    func set(_ value: UIImage?, forKey key: String) {
        if let value = value {
            setValue(value.pngData(), forKey: key)
        } else {
            setValue(nil, forKey: key)
        }
    }
}
