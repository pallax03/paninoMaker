//
//  NotificationManager.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 06/06/25.
//

import UserNotifications

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Permesso notifiche garantito ✅")
        } else {
            print("Permesso notifiche negato ❌")
        }
    }
    
}

func sendNotification(_ level: Int, message: String) {
    let content = UNMutableNotificationContent()
    content.title = "Level UPPP"
    content.body = "Sei \(message)al Livello \(level)!"
    content.sound = UNNotificationSound.default

    // Puoi scegliere di farla apparire subito o con un ritardo
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Errore: \(error.localizedDescription)")
        } else {
            print("Notifica programmata!")
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
