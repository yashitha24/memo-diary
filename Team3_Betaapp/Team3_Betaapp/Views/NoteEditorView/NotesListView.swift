//
//  NotesListView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/30/23.
//
import SwiftUI
struct NotesListView: View {
    @ObservedObject var viewModel: CalendarViewModel  // ViewModel managing the notes.
    @Binding var selectedTab: Int // Binding to the selected tab in the parent view.
    @State private var selectedDate: Date? // State to track the currently selected date.
    @Environment(\.presentationMode) var presentationMode // Manages the view's presentation state.
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar for note filtering.
                SearchBar(text: $viewModel.searchQuery)
                // List displaying notes, categorized by date.
                List {
                    ForEach(Array(viewModel.filteredNotes.keys).sorted(), id: \.self) { date in
                        // Only display dates with associated notes.
                        if viewModel.filteredNotes[date] != nil {
                            // Button to select a date and display its notes.
                            Button(action: {
                                selectedDate = date
                            }) {
                                Text(viewModel.format(date: date))
                            }
                        }
                    }
                }
                .navigationTitle("Saved Notes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("X")
                                .font(.headline)
                                .foregroundColor(CustomColor.blue)
                        }
                    }
                }
                .background(
                    // Navigation to NoteEditorView when a date is selected.
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
}


