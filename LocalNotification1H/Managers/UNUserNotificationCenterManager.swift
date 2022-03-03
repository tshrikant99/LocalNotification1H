//
//  UNUserNotificationCenterManager.swift
//  LocalNotification1H
//
//  Created by Amin Siddiqui on 20/01/22.
//

import UIKit
import UserNotifications

class UNUserNotificationCenterManager: NSObject {
    static let shared = UNUserNotificationCenterManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func enable() {
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Error in request authorize \(error.localizedDescription)")
            } else {
                NotificationHandler.registerCategoryActions()
            }
        }
    }
}

extension UNUserNotificationCenterManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let categoryIdentifierRawValue = response.notification.request.content.categoryIdentifier
        guard let categoryID = UNNotificationCategory.CustomKeys(rawValue: categoryIdentifierRawValue)
        else { return }

        let actionIdentifierRawValue = response.actionIdentifier
        switch categoryID {
        case .contest:
            guard let actionIdentifier = UNNotificationAction.ContestActions(rawValue: actionIdentifierRawValue) else { return }

            switch actionIdentifier {
            case .playNow:
                print("show contest")
            case .remindMeLater:
                print("reschedule the notification after 10 secs")
            case .ignore:
                print("do nothing")
            }
        case .game:
            print("show game")
        }
    }
}

extension UNNotificationCategory {
    enum CustomKeys: String {
        case contest
        case game
    }
}

extension UNNotificationAction {
    enum ContestActions: String {
        case playNow
        case remindMeLater
        case ignore
        
        var title: String {
            switch self {
            case .playNow       : return "Play Now"
            case .remindMeLater : return "Remind me later"
            case .ignore        : return "Don't remind me"
            }
        }
    }
}
