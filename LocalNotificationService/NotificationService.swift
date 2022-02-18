//
//  NotificationService.swift
//  LocalNotificationService
//
//  Created by shrikant on 01/02/22.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            // Save notification data to UserDefaults
            let data = bestAttemptContent.userInfo as NSDictionary
            let pref = UserDefaults.init(suiteName: "group.com.local.notification1H.LocalNotification1H")
            pref?.set(data, forKey: "NOTIF_DATA")
            pref?.synchronize()
            
            guard let attachmentURLString = bestAttemptContent.userInfo["attachment-url"] as? String else {
                contentHandler(bestAttemptContent)
                return
            }
            
            if let attachmentUrl = URL(string: attachmentURLString) {
                let downloadTask = URLSession(configuration: .default).downloadTask(with: attachmentUrl) { url, response, error in
                    if let url = url {
                        let attachment = try! UNNotificationAttachment(identifier: "image.jpg", url: url)
                        bestAttemptContent.attachments = [attachment]
                    }
                }
                downloadTask.resume()
            } else {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
