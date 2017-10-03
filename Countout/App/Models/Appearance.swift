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
        backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? UIColor(red: 0.0, green: 0.0, blue: 72.0/255.0, alpha: 1.0)
        backgroundImage = UserDefaults.standard.image(forKey:"Background Image")
        fontFamily = UserDefaults.standard.string(forKey: "Font Family") ?? "AvenirNext"
        fontScale = UserDefaults.standard.cgFloat(forKey: "Font Scale") ?? 0.25
        fontWeight = UserDefaults.standard.string(forKey: "Font Weight") ?? "UltraLight"
        textColor = UserDefaults.standard.color(forKey: "Text Color") ?? UIColor(red: 1.0, green:1.0, blue:1.0, alpha:1.0)
    }
    
    func reset() {
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 72.0/255.0, alpha: 1.0)
        backgroundImage = nil
        fontFamily = "AvenirNext"
        fontScale = 0.25
        fontWeight = "UltraLight"
        textColor = UIColor(red: 1.0, green:1.0, blue:1.0, alpha:1.0)
    }
    
    var fontName: String {
        return fontFamily + "-" + fontWeight
    }
}
