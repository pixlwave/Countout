import UIKit

class OutputController: UIViewController {
    var appearance = Appearance.sharedClient
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateAppearance()
    }
    
    func updateAppearance() {
        self.view.backgroundColor = appearance.backgroundColor
        backgroundImageView.image = appearance.backgroundImage
        timeLabel.font = UIFont(name: appearance.fullFontName(), size: appearance.fontScale * self.view.frame.width)
        timeLabel.textColor = appearance.textColor
    }
}