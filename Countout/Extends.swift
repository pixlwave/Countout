import UIKit

extension UIView {
    
    func fadeIn() {
        UIView.animateWithDuration(0.3) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut() {
        UIView.animateWithDuration(0.3) {
            self.alpha = 0.0
        }
    }
    
}
