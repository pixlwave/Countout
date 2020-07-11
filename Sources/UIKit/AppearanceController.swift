import UIKit

class AppearanceController: UIViewController {
    
    let appearance = Appearance.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = String(CountdownTimer.shared.length / 60) + ":" + String(format: "%02d", CountdownTimer.shared.length.truncatingRemainder(dividingBy: 60))
    }
    
    @IBAction func chooseBackground() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate
extension AppearanceController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            appearance.backgroundImage = image
            // updateAppearance()
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
