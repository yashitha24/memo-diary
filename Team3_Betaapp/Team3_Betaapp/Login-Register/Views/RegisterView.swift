//
//  RegisterView.swift
//  login
//
//  Created by Sanjana Movva on 10/30/23.
//

import SwiftUI

// A SwiftUI view for user registration
struct RegisterView: View {
    @State private var fullName: String = "" // State variable for full name input
    @State private var email: String = "" // State variable for email input
    @State private var mobileNumber: String = "" // State variable for mobile number input
    @State private var password: String = "" // State variable for password input
    @State private var confirmPassword: String = "" // State variable for confirming password input
    @Binding var isPresented: Bool // Binding to control the presentation of this view
    @State private var isPasswordVisible: Bool = false
    @ObservedObject var viewModel: AuthViewModel // Observed object for the authentication view model
    @Environment(\.dismiss) var dismiss // Environment variable to dismiss the view
    @State private var isConfirmPasswordVisible: Bool = false
    
    var body: some View {
        ZStack{
            Image("gradient")
                .resizable()
            //.scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Begin your journey")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.blue)
                    .padding(.bottom, 80)
                // VStack for form fields
                VStack(alignment: .leading) {
                    // Full name field
                    Text("Full Name")
                        .font(.footnote)
                        .foregroundColor(CustomColor.blue)
                    TextField("Enter your name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    // Email field
                    Text("Email")
                        .font(.footnote)
                        .foregroundColor(CustomColor.blue)
                    
                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    // Mobile number field
                    Text("Mobile Number")
                        .font(.footnote)
                        .foregroundColor(CustomColor.blue)
                    TextField("Enter your mobile number", text: $mobileNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    // Password field
                        Text("Password")
                            .font(.footnote)
                            .foregroundColor(CustomColor.blue)
                        
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
                                Button(action: {
                                    self.isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: self.isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(CustomColor.blue)
                                }
                                .padding(.trailing, 8)
                            }
                        )
                    
                    // Confirm password field
                                HStack {
                                    Text("Confirm Password")
                                        .font(.footnote)
                                        .foregroundColor(CustomColor.blue)
                                    Spacer()
                                }
                                
                                ZStack(alignment: .trailing) {
                                    if isConfirmPasswordVisible {
                                        TextField("Confirm your password", text: $confirmPassword)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    } else {
                                        SecureField("Confirm your password", text: $confirmPassword)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        if !password.isEmpty && !confirmPassword.isEmpty {
                                            Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .imageScale(.large)
                                                .fontWeight(.bold)
                                                .foregroundColor(password == confirmPassword ? Color(.systemGreen) : Color(.systemRed))
                                        }
                                        // Toggle button for confirm password visibility
                                        Button(action: {
                                            self.isConfirmPasswordVisible.toggle()
                                        }) {
                                            Image(systemName: self.isConfirmPasswordVisible ? "eye.slash" : "eye")
                                                .foregroundColor(CustomColor.blue)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                }
                           

                    
                }
                .padding([.leading, .trailing, .bottom], 20)
                
                Button( action: {
                    do{
                        Task {
                            try await viewModel.createUser(withEmail: email, password: password, fullname: fullName)
                            isPresented = false
                        }
                    } catch{
                        isPresented = true
                    }
                    //                if(viewModel.isShowingUserExistAlert){
                    //                    print("Should be in Register Screen only")
                    //                    isPresented = true
                    //                }
                    //                else{
                    ////                    isPresented = false
                    //                }
                    
                    
                    
                }, label: {
                    HStack {
                        // Register button
                        Text("Register")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 65, height: 26)
                })
                .padding()
                .background(CustomColor.blue)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Text("By registering you agree to Terms & conditions and privacy Policy of the app")
                    .font(.caption)
                    .foregroundColor(CustomColor.blue)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing], 20)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    
                    Text("Already have an account? Login")
                        .font(.caption)
                        .foregroundColor(CustomColor.blue)
                        .underline()
                }
                
                
                
                
                .alert(isPresented: $viewModel.isShowingUserExistAlert) {
                    Alert(title: Text("Error"),
                          message: Text(viewModel.errorStringForCreateUser ?? "An unexpected error occurred. Please try again."),
                          dismissButton: .default(Text("OK")))
                }
                .onAppear {
                    viewModel.isShowingUserExistAlert = false
                    viewModel.errorStringForCreateUser = nil
                }
                
            }
            //.padding(.top, 50)
        }
    }
}

extension RegisterView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && confirmPassword == password
        && password.count > 5
        && !fullName.isEmpty
    }
    
}


