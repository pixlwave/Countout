import SwiftUI

extension Color {
    static let countdownBackground = Color(UIColor(named: "Countdown Background Color")!)
}


extension TimeInterval {
    static let remainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    func remainingString() -> String {
        var components = DateComponents()
        components.second = Int(max(0.0, self.rounded(.up)))
        return TimeInterval.remainingFormatter.string(from: components)!
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
