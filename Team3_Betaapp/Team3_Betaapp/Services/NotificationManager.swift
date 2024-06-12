//
//  NotificationManager.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/30/23.
//

import Foundation
import UserNotifications
class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleDailyReminder() {
        requestAuthorization { granted in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Create a Moment"
                content.body = "Create a moment today!"
                content.sound = UNNotificationSound.default
                
                var dateComponents = DateComponents()
                dateComponents.hour = 20 // 8 PM in 24-hour format
                dateComponents.minute = 20

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Daily reminder scheduled.")
                    }
                }
            }
        }
    }
}

