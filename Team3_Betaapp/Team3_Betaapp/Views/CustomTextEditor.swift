//
//  CustomTextEditor.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/30/23.
//

import Foundation
import SwiftUI

// CustomTextEditor is a UIViewRepresentable view for text editing.
struct CustomTextEditor: UIViewRepresentable {
    var backgroundColor: UIColor
    @Binding var text: String
    
    // Creates and configures the underlying UITextView.
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.delegate = context.coordinator
        return textView
    }
    
    // Updates the UITextView with the provided text and background color.
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.backgroundColor = backgroundColor
    }
    
    // Creates a Coordinator to handle UITextView delegate methods.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class to handle UITextView delegate methods.
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
