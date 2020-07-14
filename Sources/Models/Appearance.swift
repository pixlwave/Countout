import UIKit

class Appearance: ObservableObject {
    static let shared = Appearance()
    
    
    // polluted keys: ["Background Image", "Font Family"]
    @Published var backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? .countdownBackground {
        didSet { UserDefaults.standard.set(backgroundColor, forKey: "Background Color") }
    }
    @Published var backgroundImage: UIImage? {
        didSet { writeBackground() }
    }
    let fontFamily = "Avenir Next"
    @Published var fontScale = UserDefaults.standard.cgFloat(forKey: "Font Scale") ?? 0.25 {
        didSet { UserDefaults.standard.set(fontScale, forKey: "Font Scale") }
    }
    @Published var fontWeight = UserDefaults.standard.string(forKey: "Font Weight") ?? "Demi Bold" {
        didSet { UserDefaults.standard.set(fontWeight, forKey: "Font Weight") }
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
        fontWeight = "Demi Bold"
        textColor = .countdownText
    }
    
    func toggleBold() {
        fontWeight = fontWeight == "Regular" ? "Demi Bold" : "Regular"
    }
    
    var fontName: String { fontFamily + " " + fontWeight }
    
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
