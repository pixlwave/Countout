import SwiftUI
import PhotosUI

/// A custom photo picker that, unlike the SwiftUI one, remains presented until
/// the picked image has been loaded and the backgroun image is set.
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var isLoadingPhoto: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // nothing to update
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(view: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let view: PhotoPicker
        
        init(view: PhotoPicker) {
            self.view = view
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider else {
                picker.dismiss(animated: true)
                return
            }
            
            view.isLoadingPhoto = true
            
            provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                if let data {
                    Appearance.shared.backgroundImageData = data
                }
                DispatchQueue.main.async {
                    picker.dismiss(animated: true)
                    self.view.isLoadingPhoto = false
                }
            }
        }
    }
}
