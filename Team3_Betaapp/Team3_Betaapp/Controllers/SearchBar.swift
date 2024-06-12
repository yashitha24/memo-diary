//
//  SearchBar.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/30/23.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String // Binding to manage the search text input.
    @State private var isEditing = false // State variable to track whether the search bar is in editing mode or not.

    var body: some View {
        HStack {
            TextField("Search...", text: $text) // Text field for entering search text.
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass") // Search icon.
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.text = "" // Clear the search text.
                            }) {
                                Image(systemName: "multiply.circle.fill") // Clear text icon when editing.
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true // Activate editing mode when tapped.
                }

            if isEditing {
                Button(action: {
                    self.isEditing = false // Deactivate editing mode and clear search text.
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel") // Cancel button to exit editing mode.
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
