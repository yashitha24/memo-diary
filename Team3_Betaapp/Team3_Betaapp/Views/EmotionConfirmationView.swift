//
//  EmotionConfirmationView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/30/23.
//

import Foundation
import SwiftUI

// EmotionConfirmationView is a view for confirming a predicted emotion.
struct EmotionConfirmationView: View {
    let predictedEmotion: String // The predicted emotion to be confirmed.
    let onEmotionSelected: (String) -> Void // A closure to handle the selection of the confirmed emotion.
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Predicted Emotion: \(predictedEmotion)")
                .font(.headline)
            
            Text("Is this your emotion?")
            
            // Display buttons for different emotions to confirm the emotion.
            ForEach(["Happy", "Sad", "Angry", "Suprised", "Disgusted", "Fearful", "Neutral"], id: \.self) { emotion in
                Button(emotion) {
                    // When an emotion is selected, execute the provided closure.
                    onEmotionSelected(emotion)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
