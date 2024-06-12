//
//  MoreTabView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//


/*
 This file defines the MoreTabView struct, which is part of a SwiftUI application.The view
 includes additional options and settings, like accessing a photo gallery, viewing
 maps,displaying statistics, and signing out of the application.
 */

import Foundation
import SwiftUI

struct MoreTabView: View {
    // ViewModel for managing calendar-related data.
    @ObservedObject var viewModel = CalendarViewModel()
    // ViewModel for managing authentication.
    @ObservedObject var loginModel: AuthViewModel
    @State private var showingInfoView = false

    var body: some View {
        NavigationView {
                List {
                    Section {
                        HStack {
                            if let user = loginModel.currentUser {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray3))
                                    .clipShape(Circle())
                                VStack(alignment:.leading, spacing:  4) {
                                    Text(user.fullname)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                Text("T")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray3))
                                    .clipShape(Circle())
                                VStack(alignment:.leading, spacing:  4) {
                                    Text("Test")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text("test@gmail.com")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                               
                            
                           
                            
                        }
                    }
                    // Section for general options like photo gallery and maps.
                    Section(header: Text("General")) {
                        NavigationLink(destination: PhotoGalleryView(viewModel: viewModel)) {
                            Text("Photo Gallery")
                        }
                        NavigationLink(destination: MapView(
                            
                            viewModel: viewModel )) {
                                Text("Maps")
                            }
                    }
                    // Section for displaying user statistics like streaks.
                    Section(header: Text("Statistics")) {
                        HStack {
                            Text("Streaks")
                            Spacer()
                            Text("\(viewModel.calculateStreak())")
                        }
                    }
                    Section(header: Text("About")) {
                       
                        Button(action: {showingInfoView = true}){
                            Text("Info")
                                .foregroundColor(Color.black)
                        }
                    }
                    // Section for account-related actions, like signing out.
                    Section("Account") {
                        Button {
                            Task {
                                try await  loginModel.signOut()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.left.circle.fill")
                                    .imageScale(.small)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(CustomColor.blue)
                                
                                Text("Sign Out")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            
                            
                        }
                    }
                }
                .sheet(isPresented: $showingInfoView) {
                                InfoView() // The view to show in the sheet
                            }
//                .navigationTitle("More")
            }
        }
    }
    

