import UIKit

class OutputController: UIViewController {
    var appearance = Appearance.sharedClient
    
    @IBOutlet weak var countdownView: CountdownView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAppearance()
    }
    
    func updateAppearance() {
        countdownView.backgroundColor = appearance.backgroundColor
        countdownView.backgroundImage = appearance.backgroundImage
        countdownView.setFont(name: appearance.fontName, size: appearance.fontScale)
        countdownView.textColor = appearance.textColor
    }
}