import UIKit

class CountdownController: UIViewController {
    
    let countdown = CountdownTimer.sharedClient
    let appearance = Appearance.sharedClient
    
    var outputExists = false {
        didSet {
            updateOutputStatus()
        }
    }
    
    var countdownMinutes = 5
    var countdownSeconds = 0
    
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var countdownViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var countdownViewPortraintConstraints: [NSLayoutConstraint]!
    @IBOutlet var countdownViewLandscapeConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var outputStatusLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet var countdownLengthView: UIView!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var outputVC: OutputController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this controller is owner in xib file
        // loaded view has outlet set in the xib
        // frame is set in layout subviews method
        Bundle.main.loadNibNamed("CountdownLengthView", owner: self, options: nil)
        countdownLengthView.alpha = 0.0
        view.addSubview(countdownLengthView)
        
        updateCountdownLength()
        
        minutesTextField.delegate = self
        secondsTextField.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            layoutSubviewsPad()
        }
        
        // calling updateOutputStatus results in a fade out on appear
        outputStatusLabel.alpha = outputExists ? 0.0 : 1.0
        
        updateAppearance()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if UIScreen.main.bounds.height < 568 {
            countdownLengthView.frame = CGRect(x: 0, y: countdownView.frame.maxY - 36, width: view.frame.width, height: view.frame.height - countdownView.frame.maxY - 180)
        } else {
            countdownLengthView.frame = CGRect(x: 0, y: countdownView.frame.maxY, width: view.frame.width, height: view.frame.height - countdownView.frame.maxY - 216)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            layoutSubviewsPad()
        }
    }
    
    func layoutSubviewsPad() {
        switch interfaceOrientation {
        case .landscapeLeft, .landscapeRight:
            countdownViewWidthConstraint.constant = 550
            // setConstraints(countdownViewPortraintConstraints, enabled: false)
            // setConstraints(countdownViewLandscapeConstraints, enabled: true)
        default:
            countdownViewWidthConstraint.constant = 688
            // setConstraints(countdownViewLandscapeConstraints, enabled: false)
            // setConstraints(countdownViewPortraintConstraints, enabled: true)
        }
    }
    
    func setConstraints(_ constraints: [NSLayoutConstraint]!, enabled: Bool) {
        for constraint in constraints {
            constraint.isActive = enabled
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CountdownLength-iPad" {
            if let navC = segue.destination as? UINavigationController, let lengthVC = navC.visibleViewController as? CountdownLengthController {
                navC.popoverPresentationController?.delegate = self
                lengthVC.countdownMinutes = countdownMinutes
                lengthVC.countdownSeconds = countdownSeconds
                lengthVC.delegate = self
            }
        }
            
    }
    
    func updateAppearance() {
        countdownView.backgroundColor = appearance.backgroundColor
        countdownView.backgroundImage = appearance.backgroundImage
        countdownView.setFont(name: appearance.fontName, size: appearance.fontScale)
        countdownView.textColor = appearance.textColor
    }
    
    func updateCountdownLength() {
        let length = (countdownMinutes * 60) + countdownSeconds // TODO: countdownMinutes.minutes
        countdown.length = length
        
        (UIApplication.shared.delegate as! CountdownTimerDelegate).countdownHasChanged()
        updateLengthLabel()
    }
    
    func updateLengthLabel() {
        let minutesSuffix = countdownMinutes == 1 ? "minute" : "minutes"
        let secondsSuffix = countdownSeconds == 1 ? "second" : "seconds"
        
        lengthLabel.text = countdownSeconds == 0 ? "\(countdownMinutes) \(minutesSuffix)" : "\(countdownMinutes) \(minutesSuffix), \(countdownSeconds) \(secondsSuffix)"
        
        // update text fields
        minutesTextField.text = String(countdownMinutes)
        secondsTextField.text = String(countdownSeconds)
    }
    
    func updateOutputStatus() {
        if outputExists == true {
            outputStatusLabel?.fadeOut()
        } else {
            outputStatusLabel?.fadeIn()
        }
    }
    
    @IBAction func start() {
        countdown.start()
        
        startButton.isEnabled = false
        stopButton.isEnabled = true
        resetButton.isEnabled = true
    }
    
    @IBAction func stop() {
        countdown.stop()
        
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = true
    }
    
    @IBAction func reset() {
        updateCountdownLength()
        countdown.reset()
        
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = false
    }
    
    @IBAction func plusOneMinute() {
        countdown.addToRemaining(60)
        resetButton.isEnabled = true
    }
    
    @IBAction func editCountdownLength() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            countdownLengthView.fadeIn()
            minutesTextField.becomeFirstResponder()
        } else {
            performSegue(withIdentifier: "CountdownLength-iPad", sender: self)
        }
    }
    
    func finishCountdownLength() {
        view.endEditing(true)
        countdownMinutes = Int(minutesTextField.text!) ?? 0
        countdownSeconds = Int(secondsTextField.text!) ?? 0
        if countdownMinutes + countdownSeconds == 0 { countdownMinutes = 1 }
        
        if countdown.isActive() {
            updateLengthLabel() // only update countdown length label to reflect what reset will do
        } else {
            reset() // reset which updates countdown length and length label
        }
        
        countdownLengthView.fadeOut()
    }
    
    func countdownHasFinished() {
        startButton.isEnabled = false
        stopButton.isEnabled = false
        resetButton.isEnabled = true
    }
}

// MARK: UITextFieldDelegate
extension CountdownController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }    // must have an existing string
        
        if Int(text) == 0 || Int(text) == nil { textField.text = "" }
        
        guard let newInt = Int(text + string) else { return false }     // must be an Int
        
        // TODO: Swifty this more
        if textField == secondsTextField && newInt > 59 {
            return false
        } else if textField == minutesTextField && newInt > 999 {
            return false
        }
        
        return true
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension CountdownController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        // enforce confirm or cancel of change in presented controller
        return false
    }
}
