import UIKit

class Appearance {
    static let sharedClient = Appearance()
    
    var backgroundColor: UIColor { didSet { Defaults["BackgroundColor"] = NSKeyedArchiver.archivedDataWithRootObject(backgroundColor) } }
    var backgroundImage: UIImage? { didSet { Defaults["BackgroundImage"] = UIImagePNGRepresentation(backgroundImage) } }
    var fontFamily: String { didSet { Defaults["FontFamily"] = fontFamily } }
    var fontScale: CGFloat { didSet { Defaults["FontScale"] = fontScale } }
    var fontWeight: String { didSet { Defaults["FontWeight"] = fontWeight } }
    var textColor: UIColor { didSet { Defaults["TextColor"] = NSKeyedArchiver.archivedDataWithRootObject(textColor) } }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        backgroundColor = Defaults["BackgroundColor"].color ?? UIColor(red: 0.0, green: 0.0, blue: 72.0/255.0, alpha: 1.0)
        backgroundImage = Defaults["BackgroundImage"].image
        fontFamily = Defaults["FontFamily"].string ?? "AvenirNext"
        fontScale = Defaults["FontScale"].cgfloat ?? 0.25
        fontWeight = Defaults["FontWeight"].string ?? "UltraLight"
        textColor = Defaults["TextColor"].color ?? UIColor(red: 1.0, green:1.0, blue:1.0, alpha:1.0)
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
