import UIKit

class AppearanceController: UIViewController {
    
    let appearance = Appearance.sharedClient
    
    var colorPicker: STColorPicker!
    var pickColorOf = ColorOf.text
    
    enum ColorOf {
        case text
        case background
    }

    @IBOutlet weak var countdownView: CountdownView!
    
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
        
        countdownView.text = String(CountdownTimer.sharedClient.length / 60) + ":" + String(format: "%02d", (CountdownTimer.sharedClient.length % 60))
        
        borderView.backgroundColor = UIColor.clear
        borderView.layer.cornerRadius = 6.0
        borderView.layer.masksToBounds = true
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        
        Bundle.main.loadNibNamed("FontAppearanceView", owner: self, options: nil)
        fontScaleSlider.value = Float(appearance.fontScale)
        borderView.addSubview(fontView)
        fontView.constrainToMatchView(settingsView)
        
        Bundle.main.loadNibNamed("BackgroundAppearanceView", owner: self, options: nil)
        backgroundView.alpha = 0
        borderView.addSubview(backgroundView)
        backgroundView.constrainToMatchView(settingsView)
        
        colorPickerBorder.backgroundColor = UIColor.clear
        colorPickerBorder.layer.cornerRadius = 6.0
        colorPickerBorder.layer.masksToBounds = true
        colorPickerBorder.layer.borderWidth = 1.0
        colorPickerBorder.layer.borderColor = UIColor.darkGray.cgColor
        
        colorPicker = STColorPicker(frame: colorPickerBorder.bounds)
        colorPicker.colorHasChanged = { (color: UIColor?, location: CGPoint) in
            // FIXME: Forced unwraps
            if self.pickColorOf == .text { self.appearance.textColor = color! } else { self.appearance.backgroundColor = color! }
            self.updateAppearance()
        }
        
        colorPickerBorder.addSubview(colorPicker)
        
        updateAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        colorPicker.frame = colorPickerBorder.bounds
        colorPicker.setColor(self.pickColorOf == .text ? appearance.textColor : appearance.backgroundColor)
    }
    
    @IBAction func done() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let countdownController = presentingViewController as? CountdownController {
                countdownController.updateAppearance()
            }
        }
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reset() {
        appearance.reset()
        fontScaleSlider.value = Float(appearance.fontScale)
        
        updateAppearance()
    }
    
    @IBAction func chooseBackground() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
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
            pickColorOf = .text
            colorPicker.setColor(appearance.textColor)
            fontView.alpha = 1
            backgroundView.alpha = 0
        } else {
            pickColorOf = .background
            colorPicker.setColor(appearance.backgroundColor)
            fontView.alpha = 0
            backgroundView.alpha = 1
        }
    }
    
    func updateAppearance() {
        countdownView.backgroundColor = appearance.backgroundColor
        countdownView.backgroundImage = appearance.backgroundImage
        countdownView.setFont(name: appearance.fontName, size: appearance.fontScale)
        countdownView.textColor = appearance.textColor
        
        fontWeightButton.setTitle(appearance.fontWeight == "UltraLight" ? "Bold" : "Light", for: .normal)
        
        if let countdownController = presentingViewController as? CountdownController {
            if UIDevice.current.userInterfaceIdiom == .pad { countdownController.updateAppearance() }
            countdownController.outputVC?.updateAppearance()
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension AppearanceController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            appearance.backgroundImage = image
            updateAppearance()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UINavigationControllerDelegate
// needed for UIImagePickerControllerDelegate???
extension AppearanceController: UINavigationControllerDelegate {
    
}
