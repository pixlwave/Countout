import SwiftUI

class Appearance: ObservableObject {
    static let shared = Appearance()
    
    enum FontStyle: Int { case normal, light, serif, rounded }
    
    // polluted keys: ["Background Image", "Font Family", "Font Weight"]
    @Published var backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? .countdownBackground {
        didSet { UserDefaults.standard.set(backgroundColor, forKey: "Background Color") }
    }
    @Published private(set) var backgroundImage: UIImage?
    @Published var fontScale = UserDefaults.standard.value(forKey: "Font Scale") as? Double ?? 0.25 {
        didSet { UserDefaults.standard.set(fontScale, forKey: "Font Scale") }
    }
    @Published var fontStyle = FontStyle(rawValue: UserDefaults.standard.integer(forKey: "Font Style")) ?? .normal {
        didSet { UserDefaults.standard.set(fontStyle.rawValue, forKey: "Font Style") }
    }
    @Published var textColor = UserDefaults.standard.color(forKey: "Text Color") ?? .countdownText {
        didSet { UserDefaults.standard.set(textColor, forKey: "Text Color") }
    }
    @Published var earlyWarningColor = UserDefaults.standard.color(forKey: "Early Warning Color") ?? .earlyWarning {
        didSet { UserDefaults.standard.set(earlyWarningColor, forKey: "Early Warning Color") }
    }
    @Published var finalWarningColor = UserDefaults.standard.color(forKey: "Final Warning Color") ?? .finalWarning {
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
