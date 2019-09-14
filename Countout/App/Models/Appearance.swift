import UIKit

class Appearance {
    static let sharedClient = Appearance()
    
    var backgroundColor = UserDefaults.standard.color(forKey: "Background Color") ?? .countdownBackground {
        didSet { UserDefaults.standard.set(backgroundColor, forKey: "Background Color") }
    }
    var backgroundImage = UserDefaults.standard.image(forKey:"Background Image") {
        didSet { writeBackground() }
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
    
    init() {
        // backgroundImage initially attempts to load from now removed user defaults storage
        if backgroundImage == nil {
            // load the background from disk if user defaults has no value
            backgroundImage = readBackground()
        } else {
            // otherwise transition to storing backgroundImage as a file on disk
            writeBackground()
            UserDefaults.standard.removeObject(forKey: "Background Image")
        }
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
    
    func readBackground() -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return UIImage(contentsOfFile: documentDirectory.appendingPathComponent("Background.png").path)
    }
    
    func writeBackground() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        if let backgroundImage = backgroundImage {
            try? backgroundImage.pngData()?.write(to:  documentDirectory.appendingPathComponent("Background.png"))
        } else {
            try? FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("Background.png"))
        }
    }
}
