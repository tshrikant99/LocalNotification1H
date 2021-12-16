//
//  NotificationHandler.swift
//  LocalNotification1H
//
//  Created by shrikant on 16/12/21.
//

import UIKit
import UserNotifications

struct NotificationHandler {
    
    let notifyAfter: TimeInterval = 8
    let notificationTitle = "1 Huddle"
    let notificationMessage = "Hey! A contest is ending today & you haven't played some games, Play now! so you don't miss out."
    let categoryIdentifier = "My category"
    
    let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate
    
    init() {
        
    }
    
    func requestAuthorization() {
        appDelegateInstance.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Error in request authorize \(error.localizedDescription)")
            }
        }
    }
    
    func send1huddleNotification() {
        let content = createNotificationContent(title: notificationTitle, message: notificationMessage)
        sendNotificationRequest(content: content, notifyAfter: notifyAfter)
        
        let playNowAction = getNotificationAction(title: "Play now!", actionIdentifier: .playNow, actionType: .foreground)
        let remindAction = getNotificationAction(title: "Remind me later", actionIdentifier: .remindMe, actionType: .foreground)
        let playLaterAction = getNotificationAction(title: "I'll Play later", actionIdentifier: .playLater, actionType: .destructive)
        addNotificationActions(customActions: playNowAction, remindAction, playLaterAction)
    }
    
    // Create content
    func createNotificationContent(title: String, message: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryIdentifier
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        return content
    }
    
    // Notification request
    func sendNotificationRequest(content: UNMutableNotificationContent, notifyAfter: TimeInterval) {
        var dateComponent = DateComponents()
        dateComponent.second = Calendar.current.component(.second, from: Date.now.addingTimeInterval(10))
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponent, repeats: false)
        
        let req = UNNotificationRequest.init(identifier: "Notify", content: content, trigger: trigger)
        
        appDelegateInstance.notificationCenter.add(req) { error in
            if let error = error {
                print("Error in request notification \(error.localizedDescription)")
            }
        }
    }
    
    // Create action
    func getNotificationAction(title: String, actionIdentifier: actionIdentiifier, actionType: UNNotificationActionOptions) -> UNNotificationAction {
        let action = UNNotificationAction.init(identifier: actionIdentifier.rawValue, title: title, options: actionType)
        
        return action
    }
    
    // Add actions
    func addNotificationActions(customActions: UNNotificationAction...) {
        
        let category = UNNotificationCategory.init(identifier: categoryIdentifier, actions: customActions, intentIdentifiers: [], options: [])
        
        appDelegateInstance.notificationCenter.setNotificationCategories([category])
    }
}
