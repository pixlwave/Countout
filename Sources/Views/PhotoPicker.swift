import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
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
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            view.isLoadingPhoto = true
            
            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        Appearance.shared.backgroundImage = image
                    }
                }
                self.view.isLoadingPhoto = false
                self.view.isPresented = false
            }
        }
    }
}
