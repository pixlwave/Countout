import UIKit

class Appearance {
    static let sharedClient = Appearance()
    
    var backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? .countdownBackground {
        didSet { UserDefaults.standard.set(backgroundColor, forKey: "Background Color") }
    }
    var backgroundImage = UserDefaults.standard.image(forKey:"Background Image") {
        didSet { UserDefaults.standard.set(backgroundImage, forKey: "Background Image") }
    }
    var fontFamily = UserDefaults.standard.string(forKey: "Font Family") ?? "AvenirNext" {
        didSet { UserDefaults.standard.set(fontFamily, forKey: "Font Family") }
    }
    var fontScale = UserDefaults.standard.cgFloat(forKey: "Font Scale") ?? 0.25 {
        didSet { UserDefaults.standard.set(fontScale, forKey: "Font Scale") }
    }
    var fontWeight = UserDefaults.standard.string(forKey: "Font Weight") ?? "UltraLight" {
        didSet { UserDefaults.standard.set(fontWeight, forKey: "Font Weight") }
    }
    var textColor = UserDefaults.standard.color(forKey: "Text Color") ?? .white {
        didSet { UserDefaults.standard.set(textColor, forKey: "Text Color") }
    }
    
    func reset() {
        backgroundColor = .countdownBackground
        backgroundImage = nil
        fontFamily = "AvenirNext"
        fontScale = 0.25
        fontWeight = "UltraLight"
        textColor = .white
    }
    
    var fontName: String {
        return fontFamily + "-" + fontWeight
    }
}
