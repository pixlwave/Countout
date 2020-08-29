import SwiftUI

class Appearance: ObservableObject {
    static let shared = Appearance()
    
    enum FontStyle: Int { case normal, light, serif, rounded }
    
    // polluted keys: ["Background Image", "Font Family", "Font Weight"]
    @Published var backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? .countdownBackground {
        didSet { UserDefaults.standard.set(backgroundColor, forKey: "Background Color") }
    }
    @Published var backgroundImage: UIImage? {
        didSet { writeBackground() }
    }
    @Published var fontScale = UserDefaults.standard.cgFloat(forKey: "Font Scale") ?? 0.25 {
        didSet { UserDefaults.standard.set(fontScale, forKey: "Font Scale") }
    }
    @Published var fontStyle = FontStyle(rawValue: UserDefaults.standard.integer(forKey: "Font Style")) ?? .normal {
        didSet { UserDefaults.standard.set(fontStyle.rawValue, forKey: "Font Style") }
    }
    @Published var textColor = UserDefaults.standard.color(forKey: "Text Color") ?? .countdownText {
        didSet { UserDefaults.standard.set(textColor, forKey: "Text Color") }
    }
    
    init() {
        // load the backgroundImage from disk
        readBackground()
    }
    
    func reset() {
        backgroundColor = .countdownBackground
        backgroundImage = nil
        fontScale = 0.25
        fontStyle = .normal
        textColor = .countdownText
    }
    
    func font(for width: CGFloat) -> Font {
        let size = fontScale * width
        
        switch fontStyle {
        case .normal:
            return Font.system(size: size, weight: .semibold, design: .default).monospacedDigit()
        case .light:
            return Font.system(size: size, weight: .light, design: .default).monospacedDigit()
        case .serif:
            return Font.system(size: size, weight: .medium, design: .serif).monospacedDigit()
        case .rounded:
            return Font.system(size: size, weight: .medium, design: .rounded).monospacedDigit()
        }
    }
    
    private func readBackground() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        backgroundImage = UIImage(contentsOfFile: documentDirectory.appendingPathComponent("Background.png").path)
    }
    
    private func writeBackground() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        if let backgroundImage = backgroundImage {
            try? backgroundImage.pngData()?.write(to:  documentDirectory.appendingPathComponent("Background.png"))
        } else {
            try? FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("Background.png"))
        }
    }
}
