import UIKit

class OutputController: UIViewController {
    
    // prevent external screen from appearing rotated
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}
