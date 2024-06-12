//
//  AuthView.swift
//  login
//
//  Created by Sanjana Movva on 10/30/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
// Protocol to ensure that a form adheres to a validation criterion
protocol AuthenticationFormProtocol {
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    // Published properties to update the UI on change
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorString: String?
    @Published var isShowingErrorAlert = false
    @Published var errorStringForCreateUser: String?
    @Published var isShowingUserExistAlert = false
    // Computed property to check if the user is logged in
    var isUserLoggedIn: Bool {
        userSession != nil
    }
    // Initializer to fetch the current user
    init() {
        
        Task {
            await fetchUser()
        }
        
    }
    // Asynchronous function to sign in a user with Firebase Authentication
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            
        } catch {
            print("DEBUG: Failed to login with error. \(error.localizedDescription)")
            self.errorString = "Sign in failed. Please check your email and password and try again."
            self.isShowingErrorAlert = true
        }
        
    }
    // Asynchronous function to create a new user with Firebase Authentication
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error. \(error.localizedDescription)")
            self.errorStringForCreateUser = "User Already Exists with that email. Please use different email."
            self.isShowingUserExistAlert = true
        }
        
    }
    // Function to sign out the current user
    func signOut() {
        print("Signout function called")
        do {
            try Auth.auth().signOut()
            print("Signout was done")
            self.userSession = nil
            self.currentUser = nil
            print("User session is \(String(describing: self.userSession))")
        } catch {
            print("DEBUG: Failed to sign out with error. \(error.localizedDescription)")
        }
    }
    // Asynchronous function to fetch the current user's details from Firestore
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current User is \(self.currentUser)")
    }
    
}
