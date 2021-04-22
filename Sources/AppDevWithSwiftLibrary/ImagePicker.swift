import Foundation
import SwiftUI

public class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding public var isShown: Bool
    @Binding public var image: Image?
    
    public init(isShown: Binding<Bool>, image: Binding<Image?>) {
        _isShown = isShown
        _image = image
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = Image(uiImage: uiImage)
        isShown = false  // close the image picker controller
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
public struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding public var isShown: Bool
    @Binding public var image: Image?
    
    public init(isShown: Binding<Bool>, image: Binding<Image?>) {
        _isShown = isShown
        _image = image
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
         
    }
    
    public func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}
