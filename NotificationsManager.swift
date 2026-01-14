import Foundation
import UserNotifications

struct NotificationsManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    static func scheduleExpenseReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Budget Reminder"
        content.body = "Don't forget to log your expenses today!"
        content.sound = .default
        
        // Schedule for next day at 8 PM
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "expenseReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule reminder: \(error.localizedDescription)")
            }
        }
    }
    
    static func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
