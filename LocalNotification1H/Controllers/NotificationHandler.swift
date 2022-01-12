//
//  NotificationHandler.swift
//  LocalNotification1H
//
//  Created by shrikant on 16/12/21.
//

import UIKit
import UserNotifications

struct NotificationHandler {
    
    static func send1huddleNotification() {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My category"
        content.title = "1 Huddle"
        content.body = "Hey! A contest is ending today & you haven't played some games, Play now! so you don't miss out."
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        sendNotificationRequest(content: content, notifyAfter: 8)
        
        let playNowAction = UNNotificationAction.init(identifier: ActionIdentifier.playNow.rawValue, title: "Play now!", options: .foreground)
        let remindAction = UNNotificationAction.init(identifier: ActionIdentifier.remindMe.rawValue, title: "Remind me later", options: .foreground)
        let playLaterAction = UNNotificationAction.init(identifier: ActionIdentifier.playLater.rawValue, title: "I'll Play later", options: .destructive)
        
        let category = UNNotificationCategory.init(identifier: "My category", actions: [playNowAction, remindAction, playLaterAction], intentIdentifiers: [], options: [])
        
        (UIApplication.shared.delegate as! AppDelegate).notificationCenter.setNotificationCategories([category])
    }
    
    // Notification request
    static func sendNotificationRequest(content: UNMutableNotificationContent, notifyAfter: TimeInterval) {
        var dateComponent = DateComponents()
        dateComponent.second = Calendar.current.component(.second, from: Date.now.addingTimeInterval(10))
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponent, repeats: false)
        
        let req = UNNotificationRequest.init(identifier: "Notify", content: content, trigger: trigger)
        
        (UIApplication.shared.delegate as! AppDelegate).notificationCenter.add(req) { error in
            if let error = error {
                print("Error in request notification \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - Send 1H notification for incorrect answer
extension NotificationHandler {
    
    static func scheduleQuestionNotification(for question: Question) {
        let categoryID = "question"
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryID
        content.title = "Question"
        content.body = question.title
        content.userInfo = ["data": try! JSONEncoder().encode(question)]
        
        //TODO: set image from url on notification
        //Remote URL -> Bundle URL; Downloading image & saving locally to generate a bundle url
        
        var imageDownloaded: UIImage!
        if let url = URL(string: question.imageURL) {
            
            DispatchQueue.main.async {
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if error != nil {
                        print("Error in image URL data task! \(error?.localizedDescription ?? "")")
                    } else {
                        if let imageData = data {
                            imageDownloaded = UIImage(data: imageData)
                            let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                            
                            if let data = imageDownloaded.pngData(),
                                let filePathURL = pathURL?.appendingPathComponent("notificationImage.png") {
                                try? data.write(to: filePathURL)
                                
                                do {
                                    let imageAttachment = try UNNotificationAttachment.init(identifier: "notificationImage.png", url: filePathURL, options: .none)
                                    content.attachments = [imageAttachment]
                                    
                                    let actions: [UNNotificationAction] = question.answers.map { option in
                                        let actionID = "Answer|\(option.value)"
                                        return UNNotificationAction(identifier: actionID, title: option.value, options: .foreground)
                                    }
                                    
                                    let notificationCategory = UNNotificationCategory(identifier: categoryID, actions: actions, intentIdentifiers: [], options: [])
                                    
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.notificationCenter.setNotificationCategories([notificationCategory])
                                    
                                    NotificationHandler.sendNotificationRequest(content: content, notifyAfter: 2)
                                } catch {
                                    print("error in image attachment : \(error)")
                                }
                            }
                        }
                    }
                }.resume()
            }
        } else { print("Invalid image URL in Question") }
    }
}
