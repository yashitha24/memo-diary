//
//  Team3_BetaappApp.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

import SwiftUI
import Firebase
@main
struct Team3_BetaappApp: App {
    init() {
        FirebaseApp.configure()
        NotificationManager.shared.scheduleDailyReminder()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
