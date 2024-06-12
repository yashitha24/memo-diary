//
//  CalendarViewModel.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

class CalendarViewModel: ObservableObject {
    @Published var currentMonth = Date()
    @Published var selectedDate: Date?
    @Published var isShowingNoteEditor = false
    let calendar = Calendar.current
    @Published var notes: [Date: String] = [:]
    @Published var imagesForDates: [Date: [UIImage]] = [:]
    @Published var emotionsForDates: [Date: String] = [:]
    @Published var backgroundColorForDates: [Date: UIColor] = [:]
    @Published var locationForDates : [Date : CLLocation] = [:]
    @Published var audioForDates: [Date: URL] = [:]
    @Published var selectedMonth: Date = Date()
//    init() {
//            let sampleData = [
//                "Nov 1, 2023": "Attend Computer Science Seminar in Philip Guthrie Hoffman Hall",
//                "Nov 5, 2023": "Group study session for finals at M.D. Anderson Library",
//                "Nov 10, 2023": "Presentation on Machine Learning at Cullen College of Engineering",
//                // ... (other sample data)
//            ]
//
//            for (dateString, note) in sampleData {
//                if let date = dateFormatter.date(from: dateString) {
//                    notes[date] = note
//                }
//            }
//
//            // ... (any other initialization code)
//        }
    func addSampleData() {
        print("Sampled Data Called Function")
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()

        // Sample notes and dates
        let sampleNotes = [
            "Nov 1, 2023": "Attend Computer Science Seminar in Philip Guthrie Hoffman Hall",
            "Nov 2, 2023": "Messed up the ML exam",
            "Nov 3, 2023": "Presentation on Machine Learning at Cullen College of Engineering",
            "Nov 4, 2023": "Coffee meet-up with mentor at Student Center South",
            "Nov 5, 2023": "Volunteer at UH Food Pantry, Student Center North"
            // ... add more notes here
        ]

        let sampleEmotions = [
            "Nov 1, 2023": "Happy",
            "Nov 2, 2023": "Angry", // Assigning a sample emotion for Nov 2
            "Nov 3, 2023": "Fearful",  // Assigning a sample emotion for Nov 3
            "Nov 4, 2023": "Disgusted",  // Assigning a sample emotion for Nov 4
            "Nov 5, 2023": "Sad",
        ]


        // Sample locations and dates
        let sampleLocations: [String: CLLocation] = [
            "Nov 1, 2023": CLLocation(latitude: 29.723040, longitude: -95.346460),
            "Nov 2, 2023": CLLocation(latitude: 29.712749, longitude: -95.341370),
            "Nov 3, 2023": CLLocation(latitude: 29.716660, longitude: -95.339851),
            "Nov 4, 2023": CLLocation(latitude: 29.7203809, longitude: -95.340800),
            "Nov 5, 2023": CLLocation(latitude: 29.724380, longitude:  -95.347190),
        ]

        // Populate notes
        for (dateString, note) in sampleNotes {
            if let date = dateFormatter.date(from: dateString) {
                notes[date] = note
            }
            print("Notes in \(notes)")
        }

        // Populate emotions
        for (dateString, emotion) in sampleEmotions {
            if let date = dateFormatter.date(from: dateString) {
                emotionsForDates[date] = emotion
            }
        }

        // Populate locations
        for (dateString, location) in sampleLocations {
            if let date = dateFormatter.date(from: dateString) {
                locationForDates[date] = location
            }
        }

        // ... You can also add sample data for images, audio, background colors, etc., in a similar manner
    }

    @Published var searchQuery: String = ""
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter
//    }()
    
    var filteredNotes: [Date: String] {
        if searchQuery.isEmpty {
            return notes
        } else {
            let lowercasedQuery = searchQuery.lowercased()
            return notes.filter { (date, note) in
                let dateString = dateFormatter.string(from: date).lowercased()
                return dateString.contains(lowercasedQuery)
            }
        }
    }
    var searchedNotes: [Date: String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM" // Format for abbreviated month (e.g., "Jan", "Feb")
        
        return notes.filter { (date, note) in
            let monthString = dateFormatter.string(from: date)
            return monthString.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    // Function to save an audio recording for a specific date.
    func saveAudio(for date: Date, audioURL: URL) {
        audioForDates[date] = audioURL
    }
    // Function to calculate and retrieve the note streak.
    func calculateStreak() -> Int {
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        while let note = notes[checkDate], !note.isEmpty {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        
        return streak
    }
    
    
    
    
    
  
    
    
    // Date formatter for string to date conversion
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Adjust the format as needed
        formatter.locale = Locale(identifier: "en_US_POSIX") // Optional, for robustness
        return formatter
    }()



    //    func calculateStreak() -> Int {
    //            // Find the most recent date with a note
    //            let sortedDatesWithNotes = notes.keys.sorted(by: { $0 > $1 })
    //            guard let mostRecentDate = sortedDatesWithNotes.first else {
    //                return 0 // No notes, so no streak
    //            }
    //            print(mostRecentDate)
    //            var streak = 0
    //            var checkDate = calendar.startOfDay(for: mostRecentDate)
    //            print(checkDate)
    //            while let note = notes[checkDate], !note.isEmpty {
    //                streak += 1
    //                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
    //            }
    //
    //            return streak
    //        }
    func loadAudio(for date: Date) -> URL? {
        return audioForDates[date]
    }
    
    
    // Function to save a note for a specific date, along with emotion, background color, and location.
    func saveNote(for date: Date, text: String, emotion: String, bgcolor : UIColor, location: CLLocation) {
        notes[date] = text
        emotionsForDates[date] = emotion
        backgroundColorForDates[date] = bgcolor
        locationForDates[date] = location
        print("Note",notes)
    }
    
    // Function to load a note for a specific date.
    func loadNote(for date: Date) -> String? {
        return notes[date]
    }
    
    // Function to load the background color for a specific date.
    func loadBg(for date:Date)-> UIColor{
        return backgroundColorForDates[date] ?? .white
    }
    
    // Function to load the emotion for a specific date.
    func loadEmotion(for date:Date)->String?{
        return emotionsForDates[date]
    }
    
    // Function to load the location for a specific date.
    func loadLocation(for date:Date) -> CLLocation?{
        return locationForDates[date] 
    }
    
    // Function to retrieve dates associated with a specific emotion.
    func datesForEmotion(_ emotion: String) -> [Date] {
        return emotionsForDates.filter { $1 == emotion }.map { $0.key }
    }
    // Function to save images for a specific date.
    func saveImages(for date: Date, images: [UIImage]) {
        imagesForDates[date, default: []].append(contentsOf: images)
    }
    // Function to load images for a specific date.
    func loadImages(for date: Date) -> [UIImage] {
        return imagesForDates[date] ?? []
    }
    // Function to check if a note or image is saved for a specific date.
    func isNoteOrImageSaved(for date: Date) -> Bool {
        let isNoteSaved = notes[date] != nil
        let isImageSaved = !(imagesForDates[date]?.isEmpty ?? true)
        return isNoteSaved || isImageSaved
    }
    
    // Function to retrieve the days of the current month.
    var days: [Date] {
        var days = [Date]()
        
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let numDays = range.count
        
        for day in 1...numDays {
            if let date = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentMonth), month: calendar.component(.month, from: currentMonth), day: day)) {
                days.append(date)
            }
        }
        
        return days
    }
    
    // Function to calculate the day of the week for the first day of the current month.
    func startDayOfWeek() -> Int {
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        let firstDayOfMonth = calendar.date(from: components)!
        let dayOfWeek = calendar.component(.weekday, from: firstDayOfMonth)
        return dayOfWeek - 1 // Subtract 1 to make Sunday == 0
    }
    // Function to determine the background color for a specific date based on saved notes or images.
    func backgroundColor(for date: Date) -> Color {
        if isNoteOrImageSaved(for: date) {
            if let emotion = emotionsForDates[date] {
                switch emotion {
                case "Happy":
                    return Color(red: 98/255, green: 219/255, blue: 45/255)
                case "Angry":
                    return .red
                case "Sad":
                    return .cyan
                case "Suprised":
                    return .yellow
                case "Disgusted":
                    return .purple
                case "Fearful":
                    return .orange
                default:
                    return .clear
                }
            } else {
                return .clear
            }
        } else {
            return .clear
        }
    }
    
    // Function to format a date for display.
    func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    // Function to navigate to the next month.
    func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
    }
    // Function to navigate to the previous month.
    func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
    }
}


extension DateFormatter {
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy" // Format for full date
        return formatter
    }()
}

