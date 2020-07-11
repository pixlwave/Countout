import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let configuration = PHPickerConfiguration(photoLibrary: .shared())
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
            
            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        Appearance.shared.backgroundImage = image
                    }
                }
            }
            
            view.isPresented = false
        }
    }
}
