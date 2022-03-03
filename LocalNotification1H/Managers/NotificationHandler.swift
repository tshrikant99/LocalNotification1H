//
//  NotificationHandler.swift
//  LocalNotification1H
//
//  Created by shrikant on 16/12/21.
//

import UIKit
import UserNotifications

struct NotificationHandler {
    
    ///We decide the different notification categories & set the relevant generic actions
    static func registerCategoryActions() {
        let contestCategory: UNNotificationCategory = {
            let action1 = UNNotificationAction(identifier: UNNotificationAction.ContestActions.playNow.rawValue,
                                               title: UNNotificationAction.ContestActions.playNow.title,
                                               options: .foreground)
            
            //TODO: This should dismiss the notification & re-schedule the same after another N secs
            let action2 = UNNotificationAction(identifier: UNNotificationAction.ContestActions.remindMeLater.rawValue,
                                               title: UNNotificationAction.ContestActions.remindMeLater.title,
                                               options: .destructive)
            
            let action3 = UNNotificationAction(identifier: UNNotificationAction.ContestActions.ignore.rawValue,
                                               title: UNNotificationAction.ContestActions.ignore.title,
                                               options: .destructive)
            
            let category = UNNotificationCategory(identifier: UNNotificationCategory.CustomKeys.contest.rawValue,
                                                  actions: [action1, action2, action3],
                                                  intentIdentifiers: [])
            return category
        }()
        
        DispatchQueue.main.async {
            UNUserNotificationCenterManager
                .shared
                .notificationCenter
                .setNotificationCategories([contestCategory])
        }
    }
    
    private static func sendNotificationRequest(content: UNNotificationContent, notifyAfter: TimeInterval) {
        var dateComponent = DateComponents()
        dateComponent.second = Calendar.current.component(.second, from: Date.now.addingTimeInterval(notifyAfter))
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponent, repeats: false)
        
        let req = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenterManager.shared.notificationCenter.add(req) { error in
            print(error?.localizedDescription)
        }
    }
}

//MARK: Scheduling Notification
extension NotificationHandler {
    
    static func scheduleContestReminder() {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = UNNotificationCategory.CustomKeys.contest.rawValue
        
        content.title = "1 Huddle"
        content.body = "Hey! A contest is ending today & you haven't played some games, Play now! so you don't miss out."
        
        sendNotificationRequest(content: content, notifyAfter: 2)
    }
    
    static func scheduleNotification(for game: Game) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = UNNotificationCategory.CustomKeys.game.rawValue
        content.title = game.title
        content.userInfo = ["data": try! JSONEncoder().encode(game)]
        
        sendNotificationRequest(content: content, notifyAfter: 1)
    }
}

extension NotificationHandler {
    static func showGifNotification(gifURL: String) {
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = UNNotificationCategory.CustomKeys.contest.rawValue
        
        content.title = "Error "
        content.body = "Hey! how did you got this error. LOL :D"
        
        if let url = URL(string: gifURL) {
            downloadImage(type: .gif, from: url) { bundleUrl in
                if  let bundleURL = bundleUrl,
                    let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: bundleURL) {
                    content.attachments = [attachment]
                }
                
                DispatchQueue.main.async {
                    sendNotificationRequest(content: content, notifyAfter: 2)
                }
            }
        }
    }
}
