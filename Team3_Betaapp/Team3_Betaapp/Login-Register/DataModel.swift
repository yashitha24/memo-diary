//
//  DataModel.swift
//  login
//
//  Created by Sanjana Movva on 10/30/23.
//

import Foundation
// Definition of a User struct, conforming to Identifiable and Codable protocols
struct User: Identifiable, Codable {
    // Properties of the User struct
    let id: String // Unique identifier for the user, required by Identifiable
    let fullname: String // User's full name
    let email: String // User's email address
    // Computed property to extract initials from the user's full name
    var initials: String {
        // Utilizes PersonNameComponentsFormatter for localized formatting
        let formatter = PersonNameComponentsFormatter()
        // Attempts to create a name components object from the full name
        if let components = formatter.personNameComponents(from: fullname) {
            // Sets the formatter style to abbreviated (initials)
            formatter.style = .abbreviated
            // Returns the formatted string (initials)
            return formatter.string(from: components)
        }
            
          return ""
    }
}

extension User {
    // Static property to create a predefined mock user
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "yashitha", email: "test2@gmail.com")
}
