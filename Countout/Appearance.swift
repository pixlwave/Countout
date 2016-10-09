import UIKit

class Appearance {
    static let sharedClient = Appearance()
    
    var backgroundColor: UIColor { didSet { Defaults["Background Color"] = NSKeyedArchiver.archivedData(withRootObject: backgroundColor) } }
    var backgroundImage: UIImage? { didSet {
        if let image = backgroundImage {
            Defaults["Background Image"] = UIImagePNGRepresentation(image)
        } else {
            Defaults["Background Image"] = nil
        }
    } }
    var fontFamily: String { didSet { Defaults["Font Family"] = fontFamily } }
    var fontScale: CGFloat { didSet { Defaults["Font Scale"] = fontScale } }
    var fontWeight: String { didSet { Defaults["Font Weight"] = fontWeight } }
    var textColor: UIColor { didSet { Defaults["Text Color"] = NSKeyedArchiver.archivedData(withRootObject: textColor) } }
    
    // TODO: Why am I here?!
    let defaults = UserDefaults.standard
    
    init() {
        backgroundColor = Defaults["Background Color"].color ?? UIColor(red: 0.0, green: 0.0, blue: 72.0/255.0, alpha: 1.0)
        backgroundImage = Defaults["Background Image"].image
        fontFamily = Defaults["Font Family"].string ?? "AvenirNext"
        fontScale = Defaults["Font Scale"].cgfloat ?? 0.25
        fontWeight = Defaults["Font Weight"].string ?? "UltraLight"
        textColor = Defaults["Text Color"].color ?? UIColor(red: 1.0, green:1.0, blue:1.0, alpha:1.0)
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
