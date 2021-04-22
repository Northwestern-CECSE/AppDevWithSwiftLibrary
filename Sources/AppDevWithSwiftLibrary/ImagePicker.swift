import Foundation
import SwiftUI
import AVFoundation

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
    
    public func askPermissionForCamera() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (success) in
            print(success)
        }
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
         
    }
    
    public func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.delegate = context.coordinator
        return picker
    }
}
