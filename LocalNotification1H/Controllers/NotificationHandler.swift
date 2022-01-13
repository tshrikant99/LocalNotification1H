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
    static func sendNotificationRequest(content: UNNotificationContent, notifyAfter: TimeInterval) {
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
    
    typealias DownloadImageCompletion = (URL?)->Void
    
    static func downloadImage(from url: URL, directory: FileManager.SearchPathDirectory = .documentDirectory, completion: @escaping DownloadImageCompletion) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let imageName = UUID().uuidString
            if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.9),
               let saveToURL = FileManager.default.urls(for: directory, in: .userDomainMask).first?.appendingPathComponent("\(imageName).jpg") {
                do {
                    try imageData.write(to: saveToURL)
                    completion(saveToURL)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
        }
        .resume()
    }
    
    static func scheduleQuestionNotification(for question: Question) {
        let categoryID = "question"
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryID
        content.title = "Question"
        content.body = question.title
        content.userInfo = ["data": try! JSONEncoder().encode(question)]
        
        func schedule(_ content: UNNotificationContent) {
            let actions: [UNNotificationAction] = question.answers.map { option in
                let actionID = "Answer|\(option.value)"
                return UNNotificationAction(identifier: actionID, title: option.value, options: .foreground)
            }
            
            let notificationCategory = UNNotificationCategory(identifier: categoryID, actions: actions, intentIdentifiers: [], options: [])
            
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.notificationCenter.setNotificationCategories([notificationCategory])
                
                NotificationHandler.sendNotificationRequest(content: content, notifyAfter: 2)
            }
        }
        
        
        if let url = URL(string: question.imageURL) {
            downloadImage(from: url) { bundleURL in
                if  let bundleURL = bundleURL,
                    let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: bundleURL) {
                    content.attachments = [attachment]
                }
                
                schedule(content)
            }
        } else {
            schedule(content)
        }
    }
}
