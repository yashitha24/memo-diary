//
//  InfoView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/30/23.
//

import Foundation
import SwiftUI

struct InfoView: View {
    // Environment variable to control the presentation state
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Spacer() // Pushes the button to the right
                    Button(action: {
                        // Dismiss the view when the button is tapped
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill") // 'X' icon
                            .imageScale(.large)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                }
                
                VStack{
                    Text("MemoDairy")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 2)

                        Text("Capture and Relive Your Moments")
                            .font(.subheadline) // Adjust the font size as needed
                            .padding(.bottom, 5)
                }
                .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Image("icon")
                    .resizable()
                //.scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                Text("Welcome to “MemoDairy”, an app meticulously crafted to encapsulate the moments and memories that form the mosaic of your life. In the hustle and bustle of daily life, we often let moments big and small slip by. Our app ensures these moments are not only saved but also relived with the vibrancy and sentiment they deserve.")
                    .font(.body)
                    .padding(.bottom, 5)
                
                Text("MemoDairy is a dynamic, not static, space. The app evolves with your emotions, reflecting your mood and allowing memories to be linked to specific locations, creating an immersive experience. Each entry transforms into an emotion-filled page in your life’s storybook.")
                    .font(.body)
                    .padding(.bottom, 10)
                
                
                Text("MemoDairy is more than just an app; it's a companion in your life journey, capturing and reliving your most cherished moments.")
                    .font(.body)
            }
            .padding()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
