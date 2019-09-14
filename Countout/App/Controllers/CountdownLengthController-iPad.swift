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
    
    override func viewWillAppear(_ animated: Bool) {
        minutesTextField.text = String(countdownMinutes)
        secondsTextField.text = String(countdownSeconds)
        
        minutesTextField.becomeFirstResponder()
    }
    
    var activeTextField: UITextField? {
        if minutesTextField.isFirstResponder {
            return minutesTextField
        } else if secondsTextField.isFirstResponder {
            return secondsTextField
        }
        return nil
    }
    
    @IBAction func keyPress(_ sender: UIButton) {
        if let textField = activeTextField {
            let input = "\(sender.tag)"
            if validateInput(input, forTextField: textField) {
                textField.insertText(input)
                UIDevice.current.playInputClick()
            }
        }
    }
    
    @IBAction func deleteKeyPress(_ sender: UIButton) {
        if let textField = activeTextField {
            textField.deleteBackward()
            UIDevice.current.playInputClick()
        }
    }
    
    #warning("FIXME: Only called manually on UIButton touch. Needs to be called for BT Keyboard")
    func validateInput(_ string: String, forTextField textField: UITextField) -> Bool {
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
    
    @IBAction func done() {
        delegate.minutesTextField.text = minutesTextField.text
        delegate.secondsTextField.text = secondsTextField.text
        delegate.finishCountdownLength()
        
        delegate.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        delegate.dismiss(animated: true, completion: nil)
    }
}
