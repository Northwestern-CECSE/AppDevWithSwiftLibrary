import Foundation
import SwiftUI
import AVFoundation

public class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding public var isShown: Bool
    @Binding public var image: Image?
    @Binding public var imagePNG: UIImage?
    
    public init(isShown: Binding<Bool>, image: Binding<Image?>, imagePNG: Binding<UIImage?>) {
        _isShown = isShown
        _image = image
        _imagePNG = imagePNG
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePNG = uiImage
        image = Image(uiImage: uiImage)
        isShown = false  // close the image picker controller
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
public struct ImagePicker: UIViewControllerRepresentable {
    public enum SourceType {
        case camera, photoLibrary
    }
    
    @Binding public var isShown: Bool
    @Binding public var image: Image?
    @Binding public var imagePNG: UIImage?
    public var source: SourceType
    
    public init(isShown: Binding<Bool>, image: Binding<Image?>, imagePNG: Binding<UIImage?>, source: SourceType) {
        _isShown = isShown
        _image = image
        _imagePNG = imagePNG
        self.source = source
    }
    
    public static func askPermissionForCamera() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (success) in
            print(success)
        }
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
         
    }
    
    public func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image, imagePNG: $imagePNG)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if source == .camera {
            picker.sourceType = UIImagePickerController.SourceType.camera
        } else {
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.image", "public.movie"]
        return picker
    }
}
