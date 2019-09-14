import UIKit

extension UserDefaults {
    func color(forKey defaultName: String) -> UIColor? {
        if let colorData = data(forKey: defaultName) {
            return NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        } else {
            return nil
        }
    }
    
    func image(forKey defaultName: String) -> UIImage? {
        if let imageData = data(forKey: defaultName) {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
    
    func cgFloat(forKey defaultName: String) -> CGFloat? {
        return object(forKey: defaultName) as? CGFloat
    }
    
    func set(_ value: UIColor?, forKey key: String) {
        if let value = value {
            setValue(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
        } else {
            setValue(nil, forKey: key)
        }
    }
    
    func set(_ value: UIImage?, forKey key: String) {
        if let value = value {
            setValue(value.pngData(), forKey: key)
        } else {
            setValue(nil, forKey: key)
        }
    }
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        }
    }
    
    func constrainToMatchView(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    }
}


extension UIColor {
    static var countdownBackground: UIColor { UIColor(named: "Countdown Background Color")! }
}


extension STColorPicker {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizers?.contains(gestureRecognizer) ?? false
    }
}
