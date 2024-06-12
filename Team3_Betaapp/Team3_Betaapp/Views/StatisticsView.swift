//
//  StatisticsView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//


/*
 This file defines the StatisticsView struct, which is a SwiftUI view for displaying
 statistics related to emotions recorded in the app. It uses the Charts framework to create a
 sector chart and provides a detailed view of notes for each emotion.
 */

import Foundation
import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: CalendarViewModel
    // State variables for managing the selected emotion and tab.
    @State private var selectedEmotion: String?
    @State private var selectedTab = 0
    
    // Array containing all emotions and a dictionary for mapping emotions to colors.
    let allEmotions = ["Sad", "Happy", "Fearful", "Disgusted", "Angry", "Suprised"]
    let emotionColors: [String: Color] = [
        "Happy": Color(red: 98/255, green: 219/255, blue: 45/255),
        "Angry": .red,
        "Sad": .cyan,
        "Suprised": .yellow,
        "Disgusted": .purple,
        "Fearful": .orange
    ]
    var body: some View {
            
            NavigationView {
                List {
                    // Section for displaying counts of each emotion.
                    Section(header: Text("Emotion Counts")) {
                        // Iterating over all emotions to display their counts.
                        ForEach(allEmotions, id: \.self) { emotion in
                            NavigationLink(destination: EmotionNotesListView(viewModel: viewModel, emotion: emotion, selectedTab: $selectedTab), tag: emotion, selection: $selectedEmotion) {
                                HStack {
                                    Text(emotion)
                                    Spacer()
                                    Text("\(emotionCounts[emotion] ?? 0)")
                                }
                            }
                        }
                    }
                    // Section for displaying a chart of emotion distribution.
                    Section(header: Text("Emotion Distribution")) {
                        Chart(chartData) { data in
                            SectorMark(
                                angle: .value("Count", data.count)
                            )
                            .foregroundStyle(by: .value("Emotion", data.emotion))
                        }
                        .frame(height: 200)
                    }
                }
                .navigationTitle("Statistics")
                .listStyle(InsetGroupedListStyle())
            }
            .navigationViewStyle(StackNavigationViewStyle())
        
    }
    // Computed property to calculate the count of each emotion.
    var emotionCounts: [String: Int] {
        var counts = Dictionary(uniqueKeysWithValues: allEmotions.map { ($0, 0) })
        for (_, emotion) in viewModel.emotionsForDates {
            counts[emotion, default: 0] += 1
        }
        return counts
    }
    
    // Computed property to create chart data from emotion counts.
    var chartData: [EmotionData] {
        allEmotions.map { emotion in
            EmotionData(emotion: emotion, count: Double(emotionCounts[emotion] ?? 0),color: emotionColors[emotion] ?? .gray)
        }
    }
}

// Struct to model data for the chart.
struct EmotionData: Identifiable {
    let id = UUID()
    let emotion: String
    let count: Double
    let color: Color
    
}
