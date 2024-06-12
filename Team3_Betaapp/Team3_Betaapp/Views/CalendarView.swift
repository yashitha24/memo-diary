//
//  CalendarView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//



/*
 
 This file defines the CalendarView struct, part of a SwiftUI application,
 designed to display a calendar interface.
 
 The view uses a CalendarViewModel to manage and display calendar data such
 as dates and events. Features include navigation through months, selection
 of specific months and years, and displaying days in a grid format.
 
 Interactive elements allow users to select dates, potentially for viewing
 or editing associated notes or events.
 
 */


import SwiftUI
struct CalendarView: View {
    // ViewModel for managing calendar data.
    @ObservedObject var viewModel: CalendarViewModel
    let today = Date()
    // State variables for showing month/year picker and storing selected values.
    @State private var showingMonthYearPicker = false
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    
    // Array of month names and years for selection.
    private var months: [String] = DateFormatter().monthSymbols
    private var years: [Int] = (1947...2099).map { $0 }
    
    // Initializes the view with the provided viewModel and sets the current month and year.
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        let calendar = Calendar.current
        _selectedMonth = State(initialValue: calendar.component(.month, from: viewModel.currentMonth))
        _selectedYear = State(initialValue: calendar.component(.year, from: viewModel.currentMonth))
    }
    
    var body: some View {
        VStack {
            // HStack for navigation buttons and month/year display.
            HStack {
                Button(action: {
                    viewModel.previousMonth()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(CustomColor.blue)
                })
                
                Spacer()
                
                Button(action: {
                    showingMonthYearPicker = true
                }) {
                    Text("\(viewModel.currentMonth, formatter: DateFormatter.monthAndYear)")
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showingMonthYearPicker) {
                    VStack {
                        Text("Select Month and Year")
                            .font(.headline)
                        
                        HStack {
                            Picker("Month", selection: $selectedMonth) {
                                ForEach(1..<months.count + 1, id: \.self) { index in
                                    Text(self.months[index - 1]).tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                            Picker("Year", selection: $selectedYear) {
                                ForEach(years, id: \.self) { year in
                                    Text(String(format: "%d", year)).tag(year) // Display year without commas
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                        
                        Button("Done") {
                            updateMonthAndYear()
                            showingMonthYearPicker = false
                        }
                        .padding()
                    }
                }
                
                
                Spacer()
                
                Button(action: {
                    viewModel.nextMonth()
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(CustomColor.blue)
                })
            }
            .padding()
            
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
            
            ForEach(0..<6, id: \.self) { row in
                HStack {
                    ForEach(0..<7, id: \.self) { column in
                        let dayIndex = row * 7 + column - viewModel.startDayOfWeek()
                        if dayIndex >= 0 && dayIndex < viewModel.days.count {
                            let day = viewModel.days[dayIndex]
                            if day <= today {
                                Button(action: {
                                    viewModel.selectedDate = day
                                    viewModel.isShowingNoteEditor = true
                                }, label: {
                                    Text("\(day, formatter: DateFormatter.day)")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .foregroundColor(CustomColor.blue)
                                        .fontWeight(.bold)
                                        .background(viewModel.backgroundColor(for: day))
                                        .cornerRadius(15)
                                })
                            } else {
                                // For future dates, show a disabled button or an empty view
                                Text("\(day, formatter: DateFormatter.day)")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        } else {
                            Text("")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
            
        }
        .padding()
    }
    
    // Function to update the month and year based on user selection.
    func updateMonthAndYear() {
        if let newDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth)) {
            viewModel.currentMonth = newDate
        }
    }
}

// DateFormatter extensions for specific date formats used in the view.
extension DateFormatter {
    static let monthAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
        
    }()
}

#Preview {
    CalendarView(viewModel: CalendarViewModel())
}

