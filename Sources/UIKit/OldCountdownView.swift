import UIKit

@IBDesignable
class OldCountdownView: UIView {
    private var fontName = "AvenirNext-UltraLight"
    private var fontScale: CGFloat = 0.25
    
    let timeLabel = UILabel()
    
    func setFont(name fontName: String, size fontScale: CGFloat) {
        self.fontName = fontName
        self.fontScale = fontScale
        updateFont()
    }
    
    func updateFont() {
        timeLabel.font = UIFont(name: fontName, size: fontScale * frame.width)
    }
}
