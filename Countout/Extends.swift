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
    
    func constrainToMatchView(view: UIView) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
}
