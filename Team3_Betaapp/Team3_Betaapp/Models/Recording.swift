//
//  Recording.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/1/23.
//

import Foundation

struct Recording : Equatable {
    
    let fileURL : URL // The URL of the recorded audio file.
    let createdAt : Date // The creation date of the recording.
    var isPlaying : Bool // Flag to indicate if the recording is currently being played.
    
}
