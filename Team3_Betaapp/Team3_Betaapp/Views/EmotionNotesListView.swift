//
//  EmotionNotesListView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/28/23.
//


// This displays a list of notes associated with a specific emotion

import Foundation
import SwiftUI
struct EmotionNotesListView: View {
    @ObservedObject var viewModel: CalendarViewModel
    var emotion: String
    @State private var selectedDate: Date?
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack{
            // Display a list of dates associated with the specified emotion.
            List(viewModel.datesForEmotion(emotion).sorted(), id: \.self) { date in
                NavigationLink(destination: NoteEditorView(viewModel: viewModel, date: date, selectedTab: $selectedTab), tag: date, selection: $selectedDate) {
                    Text(viewModel.format(date: date))
                }
            }
            .navigationTitle("\(emotion) Notes")
            .background(
                // Create a hidden NavigationLink to enable navigation to the NoteEditorView.
                NavigationLink(destination: Group {
                    if let selectedDate = selectedDate {
                        NoteEditorView(viewModel: viewModel, date: selectedDate, selectedTab: $selectedTab)
                            .onDisappear {
                                self.selectedDate = nil // Reset selectedDate when navigating back
                            }
                    }
                }, isActive: .constant(selectedDate != nil)) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
}
