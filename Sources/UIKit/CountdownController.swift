import UIKit

class CountdownController: UIViewController {
    
    let countdown = CountdownTimer.shared
    let appearance = Appearance.shared
    
    var countdownMinutes = 5
    var countdownSeconds = 0
    
    @IBOutlet weak var countdownView: OldCountdownView!
    @IBOutlet weak var outputStatusLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    func updateLengthLabel() {
        let minutesSuffix = countdownMinutes == 1 ? "minute" : "minutes"
        let secondsSuffix = countdownSeconds == 1 ? "second" : "seconds"
        
        lengthLabel.text = countdownSeconds == 0 ? "\(countdownMinutes) \(minutesSuffix)" : "\(countdownMinutes) \(minutesSuffix), \(countdownSeconds) \(secondsSuffix)"
        
        // update text fields
        minutesTextField.text = String(countdownMinutes)
        secondsTextField.text = String(countdownSeconds)
    }
    
    @IBAction func finishCountdownLength() {
        countdownMinutes = Int(minutesTextField.text!) ?? 0
        countdownSeconds = Int(secondsTextField.text!) ?? 0
        if countdownMinutes + countdownSeconds == 0 { countdownMinutes = 1 }
    }
}

// MARK: UITextFieldDelegate
extension CountdownController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }    // must have an existing string
        
        if Int(text) == 0 || Int(text) == nil { textField.text = "" }
        
        guard let newInt = Int(text + string) else { return false }     // must be an Int
        
        switch (textField, newInt) {
        case (secondsTextField, 60...):
            return false
        case (minutesTextField, 1000...):
            return false
        default:
            return true
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
}
