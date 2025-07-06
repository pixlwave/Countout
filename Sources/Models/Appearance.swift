import SwiftUI
import Observation

@Observable class Appearance {
    static let shared = Appearance()
    
    enum FontStyle: Int { case normal, light, serif, rounded }
    
    // polluted keys: ["Background Image", "Font Family", "Font Weight"]
    var backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? .countdownBackground {
        didSet { UserDefaults.standard.set(backgroundColor, forKey: "Background Color") }
    }
    private(set) var backgroundImage: UIImage?
    var fontScale = UserDefaults.standard.value(forKey: "Font Scale") as? Double ?? 0.25 {
        didSet { UserDefaults.standard.set(fontScale, forKey: "Font Scale") }
    }
    var fontStyle = FontStyle(rawValue: UserDefaults.standard.integer(forKey: "Font Style")) ?? .normal {
        didSet { UserDefaults.standard.set(fontStyle.rawValue, forKey: "Font Style") }
    }
    var textColor = UserDefaults.standard.color(forKey: "Text Color") ?? .countdownText {
        didSet { UserDefaults.standard.set(textColor, forKey: "Text Color") }
    }
    var earlyWarningColor = UserDefaults.standard.color(forKey: "Early Warning Color") ?? .earlyWarning {
        didSet { UserDefaults.standard.set(earlyWarningColor, forKey: "Early Warning Color") }
    }
    var finalWarningColor = UserDefaults.standard.color(forKey: "Final Warning Color") ?? .finalWarning {
        didSet { UserDefaults.standard.set(finalWarningColor, forKey: "Second Warning Color") }
    }
    
    init() {
        // load the backgroundImage from disk
        if let backgroundImageData { backgroundImage = UIImage(data: backgroundImageData) }
    }
    
    func reset() {
        backgroundColor = .countdownBackground
        backgroundImageData = nil
        fontScale = 0.25
        fontStyle = .normal
        textColor = .countdownText
        earlyWarningColor = .earlyWarning
        finalWarningColor = .finalWarning
    }
    
    func font(for width: Double) -> Font {
        let size = fontScale * width
        
        switch fontStyle {
        case .normal:
            return .system(size: size, weight: .semibold, design: .default).monospacedDigit()
        case .light:
            return .system(size: size, weight: .light, design: .default).monospacedDigit()
        case .serif:
            return .system(size: size, weight: .medium, design: .serif).monospacedDigit()
        case .rounded:
            return .system(size: size, weight: .medium, design: .rounded).monospacedDigit()
        }
    }
    
    var backgroundImageData: Data? {
        get {
            return try? Data(contentsOf: URL.documentsDirectory.appendingPathComponent("Background Image.dat"))
        }
        set {
            if let newValue, let image = UIImage(data: newValue) {
                try? newValue.write(to: URL.documentsDirectory.appendingPathComponent("Background Image.dat"))
                DispatchQueue.main.async { self.backgroundImage = image }
            } else {
                try? FileManager.default.removeItem(at: URL.documentsDirectory.appendingPathComponent("Background Image.dat"))
                DispatchQueue.main.async { self.backgroundImage = nil }
            }
        }
    }
}

// MARK: - Mock States

extension Appearance {
    func mockOutputState() {
        reset()
        fontStyle = .light
        fontScale = 0.2575
        textColor = Color(.displayP3, red: 0.279054, green: 0.621774, blue: 0.827254)
        backgroundColor = Color(.displayP3, red: 0.954636, green: 0.926699, blue: 0.306105)
    }
    
    func mockEditState() {
        reset()
        fontStyle = .serif
        fontScale = 0.3125
        textColor = Color(.displayP3, red: 0.987309, green: 0.928095, blue: 0.841883)
        backgroundColor = Color(.displayP3, red: 0.470398, green: 0.117514, blue: 0.0537412)
    }
}
