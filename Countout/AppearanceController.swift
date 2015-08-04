import UIKit

class AppearanceController: UIViewController {
    
    let appearance = Appearance.sharedClient
    
    var colorPicker: STColorPicker!
    var pickColorOf = ColorOf.Text
    
    enum ColorOf {
        case Text
        case Background
    }

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet var fontView: UIView!
    @IBOutlet weak var fontScaleSlider: UISlider!
    @IBOutlet weak var fontWeightButton: UIButton!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var fontBackgroundControl: UISegmentedControl!
    @IBOutlet weak var colorPickerBorder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLabel.text = String(CountdownTimer.sharedClient.length / 60) + ":" + String(format: "%02d", (CountdownTimer.sharedClient.length % 60))
        
        borderView.backgroundColor = UIColor.clearColor()
        borderView.layer.cornerRadius = 6.0
        borderView.layer.masksToBounds = true
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        NSBundle.mainBundle().loadNibNamed("FontAppearanceView", owner: self, options: nil)
        fontScaleSlider.value = Float(appearance.fontScale)
        borderView.addSubview(fontView)
        layoutView(fontView, toMatchView: settingsView)
        
        NSBundle.mainBundle().loadNibNamed("BackgroundAppearanceView", owner: self, options: nil)
        backgroundView.alpha = 0
        borderView.addSubview(backgroundView)
        layoutView(backgroundView, toMatchView: settingsView)
        
        colorPickerBorder.backgroundColor = UIColor.clearColor()
        colorPickerBorder.layer.cornerRadius = 6.0
        colorPickerBorder.layer.masksToBounds = true
        colorPickerBorder.layer.borderWidth = 1.0
        colorPickerBorder.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        colorPicker = STColorPicker(frame: colorPickerBorder.bounds)
        colorPicker.colorHasChanged = { (color: UIColor!, location: CGPoint) in
            if self.pickColorOf == .Text { self.appearance.textColor = color } else { self.appearance.backgroundColor = color }
            self.updateAppearance()
        }
        
        colorPickerBorder.addSubview(colorPicker)
        
        updateAppearance()
    }
    
    func layoutView(view1: UIView, toMatchView view2: UIView) {
        view1.setTranslatesAutoresizingMaskIntoConstraints(false)
        view1.superview?.addConstraint(NSLayoutConstraint(item: view1, attribute: .Leading, relatedBy: .Equal, toItem: view2, attribute: .Leading, multiplier: 1, constant: 0))
        view1.superview?.addConstraint(NSLayoutConstraint(item: view1, attribute: .Trailing, relatedBy: .Equal, toItem: view2, attribute: .Trailing, multiplier: 1, constant: 0))
        view1.superview?.addConstraint(NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 0))
        view1.superview?.addConstraint(NSLayoutConstraint(item: view1, attribute: .Bottom, relatedBy: .Equal, toItem: view2, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    override func viewDidLayoutSubviews() {
        colorPicker.frame = colorPickerBorder.bounds
        colorPicker.setColor(self.pickColorOf == .Text ? appearance.textColor : appearance.backgroundColor)
    }
    
    @IBAction func done() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func reset() {
        appearance.reset()
        fontScaleSlider.value = Float(appearance.fontScale)
        
        updateAppearance()
    }
    
    @IBAction func chooseBackground() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .CurrentContext
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func clearBackground() {
        appearance.backgroundImage = nil
        updateAppearance()
    }
    
    @IBAction func fontScaleChanged() {
        appearance.fontScale = CGFloat(fontScaleSlider.value)
        updateAppearance()
    }
    
    @IBAction func toggleBoldFont() {
        appearance.fontWeight = appearance.fontWeight == "UltraLight" ? "DemiBold" : "UltraLight"
        updateAppearance()
    }
    
    @IBAction func fontBackgroundToggle() {
        if fontBackgroundControl.selectedSegmentIndex == 0 {
            pickColorOf = .Text
            colorPicker.setColor(appearance.textColor)
            fontView.alpha = 1
            backgroundView.alpha = 0
        } else {
            pickColorOf = .Background
            colorPicker.setColor(appearance.backgroundColor)
            fontView.alpha = 0
            backgroundView.alpha = 1
        }
    }
    
    func updateAppearance() {
        previewView.backgroundColor = appearance.backgroundColor
        previewImageView.image = appearance.backgroundImage
        previewLabel.font = UIFont(name: appearance.fullFontName(), size: appearance.fontScale * previewLabel.frame.width)
        previewLabel.textColor = appearance.textColor
        
        fontWeightButton.setTitle(appearance.fontWeight == "UltraLight" ? "Bold" : "Light", forState: .Normal)
        
        if let countdownController = presentingViewController as? CountdownController {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad { countdownController.updateAppearance() }
            countdownController.outputVC?.updateAppearance()
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension AppearanceController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            appearance.backgroundImage = image
            updateAppearance()
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: UINavigationControllerDelegate
// needed for UIImagePickerControllerDelegate???
extension AppearanceController: UINavigationControllerDelegate {
    
}
