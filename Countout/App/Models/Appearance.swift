import UIKit

class Appearance {
    static let sharedClient = Appearance()
    
    var backgroundColor: UIColor { didSet { UserDefaults.standard.set(backgroundColor, forKey: "Background Color") } }
    var backgroundImage: UIImage? { didSet { UserDefaults.standard.set(backgroundImage, forKey: "Background Image") } }
    var fontFamily: String { didSet { UserDefaults.standard.set(fontFamily, forKey: "Font Family") } }
    var fontScale: CGFloat { didSet { UserDefaults.standard.set(fontScale, forKey: "Font Scale") } }
    var fontWeight: String { didSet { UserDefaults.standard.set(fontWeight, forKey: "Font Weight") } }
    var textColor: UIColor { didSet { UserDefaults.standard.set(textColor, forKey: "Text Color") } }
    
    init() {
        backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? .countdownBackground
        backgroundImage = UserDefaults.standard.image(forKey:"Background Image")
        fontFamily = UserDefaults.standard.string(forKey: "Font Family") ?? "AvenirNext"
        fontScale = UserDefaults.standard.cgFloat(forKey: "Font Scale") ?? 0.25
        fontWeight = UserDefaults.standard.string(forKey: "Font Weight") ?? "UltraLight"
        textColor = UserDefaults.standard.color(forKey: "Text Color") ?? .white
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
