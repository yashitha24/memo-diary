//
//  LoginViewModel.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/4/23.
//

import Foundation
import LocalAuthentication
class LoginViewModel: ObservableObject {
    // Other properties and methods

    func authenticateUserWithFaceID(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself with Face ID."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success, authenticationError)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
    }
}
