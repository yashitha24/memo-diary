//
//  LoginView.swift
//  login
//
//  Created by Sanjana Movva on 10/31/23.


import SwiftUI

struct CustomColor {
    static let blue = Color("blue")
    static let lightBlue = Color("lightblue")
   
}
// A SwiftUI view for user login
struct LoginView: View {
    // State variables for storing user input and view states
    @State private var email: String = "test@gmail.com"
    @State private var password: String = "testtest"
    @State private var isPasswordVisible: Bool = false
    @State private var showingRegisterView = false
    // ViewModel for handling authentication logic
    @ObservedObject var viewModel: AuthViewModel
    @StateObject private var faceIdmodel = LoginViewModel()

    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
//                Image("gradient")
//                    .resizable()
//                    //.scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
                Image("gradient")
                    .resizable()
                    //.scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Content
                VStack(spacing: 30) {
                    Spacer()
                    // App name display
                    Text("MemoDairy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(CustomColor.blue)
                    // App icon display
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    
                    Text("COLLECT MOMENTS\nnot things")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(CustomColor.blue)
                    
                    // VStack for login fields
                    VStack(alignment: .leading) {
                        Text("EMAIL ID")
                            .font(.caption)
                            .foregroundColor(CustomColor.blue)
                        TextField("Enter your email", text: $email)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        // Password input field
                        Text("Password")
                            .font(.caption)
                            .padding(.top)
                            

                        HStack {
                                                    if isPasswordVisible {
                                                        TextField("Enter your password", text: $password)
                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    } else {
                                                        SecureField("Enter your password", text: $password)
                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    }
                                                }
                                                .overlay(
                                                    HStack {
                                                        Spacer()
                                                        // Toggle button for password visibility
                                                        Button(action: {
                                                            self.isPasswordVisible.toggle()
                                                        }) {
                                                            Image(systemName: self.isPasswordVisible ? "eye.slash" : "eye")
                                                                .foregroundColor(CustomColor.blue)
                                                        }
                                                        .padding(.trailing, 8)
                                                    }
                                                )
                        Button("Sign in with Face ID") {
                                    faceIdmodel.authenticateUserWithFaceID { success, error in
                                        if success {
                                            // Proceed with a successful authentication
                                            Task {
                                                try await viewModel.signIn(withEmail: email, password: password)
                                            }
                                        } else {
                                            // Handle the error or present an alert to the user
                                        }
                                    }
                                }
                        .foregroundColor(CustomColor.blue)
//                        NavigationLink(destination: ForgotPasswordView()) {
//                            Text("forgot password?")
//                                .font(.caption)
//                                .foregroundColor(CustomColor.blue)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Button(action: {
                        // Attempt to sign in with the provided credentials
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    }, label: {
                        HStack {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 65, height: 26)
                    })
                    .padding()
                    .background(CustomColor.blue)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .cornerRadius(10)
                
                    
                    Spacer()
                    // Navigation link to the registration view
                    NavigationLink(destination: RegisterView(isPresented: $showingRegisterView, viewModel:viewModel), isActive: $showingRegisterView) {
                        Text("Don't Have An Account? Register Now")
                            .font(.caption)
                            .foregroundColor(CustomColor.blue)
                            .underline()
                    }
                }
                .padding([.leading, .trailing], 20)
            }
            .alert(isPresented: $viewModel.isShowingErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorString ?? ""), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // Reset error states when the view appears
                viewModel.isShowingErrorAlert = false
                viewModel.errorString = nil
            }
        }
    }
    
}
// Extension to define form validation logic
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}
