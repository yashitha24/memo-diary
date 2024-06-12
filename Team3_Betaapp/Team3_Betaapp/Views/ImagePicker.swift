//
//  ImagePicker.swift
//  Team3_Betaapp
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

/*
 This file defines the ImagePicker struct, a SwiftUI view that integrates a
 PHPickerViewController for selecting images from the user's photo library. The view is
 represented in SwiftUI via the UIViewControllerRepresentable protocol, enabling the use of
 UIKit components within SwiftUI.
 */
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    // Bindings to manage the presentation state and the array of selected images.
    @Binding var isPresented: Bool
    @Binding var selectedImages: [UIImage]
    
    // Creates and configures the PHPickerViewController instance.
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    // Required by UIViewControllerRepresentable, but not used in this case.
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    // Creates a coordinator to manage the interaction between the UIKit picker and SwiftUI.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class to handle the delegation from PHPickerViewController.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // Handles the completion of image picking.
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false
            
            // Process each picked result asynchronously.
            let group = DispatchGroup()
            for result in results {
                group.enter()
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }
            // Once all images are processed, dismiss the picker.
            group.notify(queue: .main) {
                picker.dismiss(animated: true)
            }
        }
    }
}
