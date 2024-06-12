//
//  Note.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

import Foundation

struct Note: Identifiable, Codable {
    var id = UUID()    // A unique identifier for the note, conforming to the Identifiable protocol.
    var date: Date     // The date associated with the note.
    var text: String   // The text content of the note.
}
