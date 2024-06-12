//
//  NotesViewModel.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

import Foundation
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = [] // An array to store notes and trigger updates when modified.
    
    // Function to save a note. If a note with the same date exists, it updates it; otherwise, it appends a new note.
    func save(note: Note) {
        if let index = notes.firstIndex(where: { $0.date.isSameDay(as: note.date) }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }
    
    // Function to retrieve a note for a given date.
    func getNote(for date: Date) -> Note? {
        return notes.first { $0.date.isSameDay(as: date) }
    }
}

extension Date {
    // Function to check if two dates are on the same day.
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}
