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
        
        let questionCategory: UNNotificationCategory = {
            let action1 = UNNotificationAction(identifier: UNNotificationAction.QuestionActions.attemptAnswer.rawValue,
                                               title: UNNotificationAction.QuestionActions.attemptAnswer.title,
                                               options: .foreground)
            
            let action2 = UNNotificationAction(identifier: UNNotificationAction.QuestionActions.showAnswer.rawValue,
                                               title: UNNotificationAction.QuestionActions.showAnswer.title,
                                               options: .foreground)
            
            let action3 = UNNotificationAction(identifier: UNNotificationAction.QuestionActions.ignore.rawValue,
                                               title: UNNotificationAction.QuestionActions.ignore.title,
                                               options: .destructive)
            
            let category = UNNotificationCategory(identifier: UNNotificationCategory.CustomKeys.question.rawValue,
                                                  actions: [action1, action2, action3],
                                                  intentIdentifiers: [])
            return category
        }()
        
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).notificationCenter.setNotificationCategories([contestCategory, questionCategory])
        }
    }
    
    static func scheduleContestReminder() {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = UNNotificationCategory.CustomKeys.contest.rawValue
        
        content.title = "1 Huddle"
        content.body = "Hey! A contest is ending today & you haven't played some games, Play now! so you don't miss out."
        
        sendNotificationRequest(content: content, notifyAfter: 10)
    }
    
    private static func sendNotificationRequest(content: UNNotificationContent, notifyAfter: TimeInterval) {
        var dateComponent = DateComponents()
        dateComponent.second = Calendar.current.component(.second, from: Date.now.addingTimeInterval(notifyAfter))
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponent, repeats: false)
        
        let req = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
        
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
    
    private static func downloadImage(from url: URL, directory: FileManager.SearchPathDirectory = .documentDirectory, completion: @escaping DownloadImageCompletion) {
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
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = UNNotificationCategory.CustomKeys.question.rawValue
        content.title = "Question"
        content.body = question.title
        content.userInfo = ["data": try! JSONEncoder().encode(question)]
        
        if let url = URL(string: question.imageURL) {
            downloadImage(from: url) { bundleURL in
                if  let bundleURL = bundleURL,
                    let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: bundleURL) {
                    content.attachments = [attachment]
                }
                
                DispatchQueue.main.async {
                    sendNotificationRequest(content: content, notifyAfter: 10)
                }
            }
        } else {
            sendNotificationRequest(content: content, notifyAfter: 10)
        }
    }
}
