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
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
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
        NSBundle.mainBundle().loadNibNamed("CountdownLengthView", owner: self, options: nil)
        countdownLengthView.alpha = 0
        view.addSubview(countdownLengthView)
        
        updateCountdownLength()
        updateOutputStatus()
        
        minutesTextField.delegate = self
        secondsTextField.delegate = self
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return .LightContent
        } else {
            return .Default
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue) | Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if UIScreen.mainScreen().bounds.height < 568 {
            countdownLengthView.frame = CGRect(x: 0, y: previewView.frame.maxY - 36, width: view.frame.width, height: view.frame.height - previewView.frame.maxY - 180)
        } else {
            countdownLengthView.frame = CGRect(x: 0, y: previewView.frame.maxY, width: view.frame.width, height: view.frame.height - previewView.frame.maxY - 216)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateAppearance()
    }
    
    func updateAppearance() {
        previewView.backgroundColor = appearance.backgroundColor
        previewImageView.image = appearance.backgroundImage
        previewLabel.font = UIFont(name: appearance.fullFontName(), size: appearance.fontScale * previewLabel.frame.width)
        previewLabel.textColor = appearance.textColor
    }
    
    func updateCountdownLength() {
        let length = (countdownMinutes * 60) + countdownSeconds // TODO: countdownMinutes.minutes
        countdown.length = length
        
        (UIApplication.sharedApplication().delegate as! CountdownTimerDelegate).countdownHasChanged()
        updateLengthLabel()
    }
    
    func updateLengthLabel() {
        let minutesSuffix = countdownMinutes == 1 ? "minute" : "minutes"
        let secondsSuffix = countdownSeconds == 1 ? "second" : "seconds"
        
        lengthLabel.text = countdownSeconds == 0 ? "\(countdownMinutes) \(minutesSuffix)" : "\(countdownMinutes) \(minutesSuffix), \(countdownSeconds) \(secondsSuffix)"
        
        // update text fields
        minutesTextField.text = toString(countdownMinutes)
        secondsTextField.text = toString(countdownSeconds)
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
        
        startButton.enabled = false
        stopButton.enabled = true
        resetButton.enabled = true
    }
    
    @IBAction func stop() {
        countdown.stop()
        
        startButton.enabled = true
        stopButton.enabled = false
        resetButton.enabled = true
    }
    
    @IBAction func reset() {
        updateCountdownLength()
        countdown.reset()
        
        startButton.enabled = true
        stopButton.enabled = false
        resetButton.enabled = false
    }
    
    @IBAction func plusOneMinute() {
        countdown.addToRemaining(60)
        resetButton.enabled = true
    }
    
    @IBAction func editCountdownLength() {
        countdownLengthView.fadeIn()
        minutesTextField.becomeFirstResponder()
    }
    
    func finishCountdownLength() {
        view.endEditing(true)
        countdownMinutes = minutesTextField.text.toInt() ?? 0
        countdownSeconds = secondsTextField.text.toInt() ?? 0
        if countdownMinutes + countdownSeconds == 0 { countdownMinutes = 1 }
        
        if countdown.isActive() {
            updateLengthLabel() // only update countdown length label to reflect what reset will do
        } else {
            reset() // reset which updates countdown length and length label
        }
        
        countdownLengthView.fadeOut()
    }
    
    func countdownHasFinished() {
        startButton.enabled = false
        stopButton.enabled = false
        resetButton.enabled = true
    }
}

// MARK: UITextFieldDelegate
extension CountdownController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        if text.toInt() == 0 || text.toInt() == nil { textField.text = "" }
        
        if textField == secondsTextField && (text + string).toInt() > 59 {
            return false
        } else if textField == minutesTextField && (text + string).toInt() > 999 {
            return false
        }
        
        return true
    }
}
