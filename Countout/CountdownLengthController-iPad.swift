import UIKit

class CountdownLengthController: UIViewController {
    
    let countdown = CountdownTimer.sharedClient
    
    var countdownMinutes: Int!
    var countdownSeconds: Int!
    var userDismissed = false
    
    var delegate: CountdownController!
    
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var keypadView: KeypadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minutesTextField.inputView = UIView()
        secondsTextField.inputView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        minutesTextField.text = String(countdownMinutes)
        secondsTextField.text = String(countdownSeconds)
        
        minutesTextField.becomeFirstResponder()
    }
    
    var activeTextField: UITextField? {
        if minutesTextField.isFirstResponder() {
            return minutesTextField
        } else if secondsTextField.isFirstResponder() {
            return secondsTextField
        }
        return nil
    }
    
    @IBAction func keyPress(sender: UIButton) {
        if let textField = activeTextField {
            let input = "\(sender.tag)"
            if validateInput(input, forTextField: textField) {
                textField.insertText(input)
                UIDevice.currentDevice().playInputClick()
            }
        }
    }
    @IBAction func deleteKeyPress(sender: UIButton) {
        if let textField = activeTextField {
            textField.deleteBackward()
            UIDevice.currentDevice().playInputClick()
        }
    }
    
    func validateInput(string: String, forTextField textField: UITextField) -> Bool {
        let text = textField.text
        if text.toInt() == 0 || text.toInt() == nil { textField.text = "" }
        
        if textField == secondsTextField && (text + string).toInt() > 59 {
            return false
        } else if textField == minutesTextField && (text + string).toInt() > 999 {
            return false
        }
        
        return true
    }
    
    @IBAction func done() {
        delegate.minutesTextField.text = minutesTextField.text
        delegate.secondsTextField.text = secondsTextField.text
        delegate.finishCountdownLength()
        
        delegate.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel() {
        delegate.dismissViewControllerAnimated(true, completion: nil)
    }
}
