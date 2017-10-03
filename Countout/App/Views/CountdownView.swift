import UIKit

@IBDesignable
class CountdownView: UIView {
    
    var text = "5:00" { didSet { timeLabel.text = text } }
    
    var textColor = UIColor.white { didSet { timeLabel.textColor = textColor } }
    var backgroundImage: UIImage? { didSet { backgroundImageView.image = backgroundImage } }
    
    private var fontName = "AvenirNext-UltraLight"
    private var fontScale: CGFloat = 0.25
    
    let backgroundImageView = UIImageView()
    let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    func load() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = backgroundImage
        
        self.addSubview(backgroundImageView)
        backgroundImageView.constrainToMatchView(self)
        
        timeLabel.text = text
        timeLabel.textAlignment = .center
        timeLabel.textColor = textColor
        
        self.addSubview(timeLabel)
        timeLabel.constrainToMatchView(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFont()
    }
    
    func setFont(name fontName: String, size fontScale: CGFloat) {
        self.fontName = fontName
        self.fontScale = fontScale
        updateFont()
    }
    
    func updateFont() {
        timeLabel.font = UIFont(name: fontName, size: fontScale * frame.width)
    }
}