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
    
    private override init() {
        super.init()
    }
    
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
        completionHandler([.alert, .badge, .sound])
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
        case .question:
            guard let actionIdentifier = UNNotificationAction.QuestionActions(rawValue: actionIdentifierRawValue) else { return }
            
            do {
                let questionData = response.notification.request.content.userInfo["data"] as! Data
                let question = try JSONDecoder().decode(Question.self, from: questionData)
                
                switch actionIdentifier {
                case .attemptAnswer:
                    showQuestionPopup(question: question, canAttempt: true)
                case .showAnswer:
                    showQuestionPopup(question: question, canAttempt: false)
                case .ignore:
                    print("do nothing")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension UNUserNotificationCenterManager {
    
    private func showQuestionPopup(question: Question, canAttempt: Bool) {
        let vc = PopupVC(nibName: "PopupVC", bundle: nil)
        vc.viewModel = PopupVM(question: question, isAttempt: canAttempt)
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
}
