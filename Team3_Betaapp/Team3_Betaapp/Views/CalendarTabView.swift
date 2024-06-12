//
//  CalendarTabView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

/*
 View for displaying the main tab interface of the app, including a calendar, statistics, and a profile or more tab.
 */
import SwiftUI
struct CalendarTabView: View {
    // State variables for managing tab selection and presentation of notes list.
    @State private var selectedTab = 0
    @StateObject private var viewModel = CalendarViewModel()
    @EnvironmentObject var loginModel: AuthViewModel
    @State private var isShowingNotesList = false
    
    // Main body of the view
    var body: some View {

            ZStack {
                
                
                // Tab view for navigation between different sections of the app.
                TabView(selection: $selectedTab) {
                    NavigationView {
                        VStack {
                            Image("icon")
                                .resizable()
                            //.scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.top, -50)
                                .padding(.bottom, 30)
//                            Text("COLLECT MOMENTS\nnot things")
//                                .multilineTextAlignment(.center)
//                                .font(.caption)
//                                .foregroundColor(CustomColor.blue)
                            // Calendar view component with its viewModel
                            CalendarView(viewModel: viewModel)
                            //                        .navigationTitle("Calendar")
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Calendar")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        
                                    }
                                }
                                .toolbar {
                                    // Toolbar button to show notes list
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            isShowingNotesList = true
                                        }) {
                                            Image(systemName: "list.bullet")
                                        }
                                    }
                                }
                        }
                        
                        // Sheet for editing or creating notes
                        .sheet(isPresented: $viewModel.isShowingNoteEditor) {
                            if let selectedDate = viewModel.selectedDate {
                                NoteEditorView(viewModel: viewModel, date: selectedDate, selectedTab: $selectedTab)
                            }
                        }
                    }
                    
                    .navigationViewStyle(.stack)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .toolbarBackground(CustomColor.blue, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    // Statistics tab with a view for displaying user stats
                    StatisticsView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Statistics")
                        }
                        .toolbarBackground(CustomColor.blue, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarColorScheme(.dark, for: .tabBar)
                    // Profile or more options tab
                    MoreTabView(viewModel: viewModel, loginModel: loginModel)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .toolbarBackground(CustomColor.blue, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarColorScheme(.dark, for: .tabBar)
                }
                
                // Sheet to display a list of notes
                .sheet(isPresented: $isShowingNotesList) {
                    NotesListView(viewModel: viewModel, selectedTab: $selectedTab)
                }
            }
            /*.onAppear() {
             UITabBar.appearance().backgroundColor = .yellow
             }
             .tint(.purple)
             */
            .onAppear {
                       viewModel.addSampleData()
                   }
            
        }
        
    }
    

