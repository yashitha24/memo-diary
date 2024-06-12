//
//  CameraView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/31/23.
//


// CameraView is a view that presents the device's camera for image capture.
import Foundation
import SwiftUI
import AVFoundation
import UIKit
struct CameraView: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        // Handle the captured image when the user finishes picking media.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImages.append(image)
            }
            parent.isPresented = false
        }
    }
    
    @Binding var isPresented: Bool
    @Binding var selectedImages: [UIImage]
    
    // Create and configure the UIImagePickerController for camera access.
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
