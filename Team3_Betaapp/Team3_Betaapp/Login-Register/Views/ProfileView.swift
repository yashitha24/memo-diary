//
//  ProfileView.swift
//  login
//
//  Created by Sanjana Movva on 10/30/23.
//
import SwiftUI

// Declaring a new SwiftUI view for displaying a user profile

struct ProfileView: View {
    
    // Using EnvironmentObject to access shared data, in this case for authentication purposes
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        // Using a List to layout the content
        List {
            // A section for user details
            Section {
                // Horizontal stack for layout
                HStack {
                    // Displaying the user's initials in a circle
                    Text(User.MOCK_USER.initials)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(Color(.systemGray3))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                    // Vertical stack for user's full name and email
                    VStack(alignment:.leading, spacing:  4) {
                        // User's full name
                        Text(User.MOCK_USER.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        // User's email
                        Text(User.MOCK_USER.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                }
            }
            // A section for general settings (currently empty)
            Section("General") {
                
            }
            // A section for account-related actions
            Section("Account") {
                // A button for signing out
                Button {
                    // Performing an asynchronous task for sign out
                    Task {
                        try await  viewModel.signOut()
                    }
                } label: {
                    // Layout for the sign-out button
                    HStack {
                        Image(systemName: "arrow.left.circle.fill")
                            .imageScale(.small)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.red)
                        
                        Text("Sign Out")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                
                }
            }
        }
    }
}



#Preview {
    ProfileView()
}
