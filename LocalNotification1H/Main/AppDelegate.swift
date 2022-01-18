//
//  AppDelegate.swift
//  LocalNotification1H
//
//  Created by shrikant on 14/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Error in request authorize \(error.localizedDescription)")
            } else {
                NotificationHandler.registerCategoryActions()
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
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
            
            switch actionIdentifier {
            case .attemptAnswer:
                print("show popup with question content & 4 answer options that are functional")
            case .showAnswer:
                print("show popup with question content & 4 answer options with the correct answer already highlighted")
            case .ignore:
                print("do nothing")
            }
        }
//        if response.actionIdentifier.hasPrefix("Answer|") {
//            let questionData = response.notification.request.content.userInfo["data"] as! Data
//            let question = try! JSONDecoder().decode(Question.self, from: questionData)
//            
//            let correctAnswer = question.answers.first { $0.isCorrect }!.value
//            let isCorrect: Bool = {
//                let selectedAnswer = response.actionIdentifier.split(separator: "|").last!
//                return selectedAnswer == correctAnswer
//            }()
//            
//            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            
//            vc.message = "You answer was \(isCorrect ? "right" : "wrong & The correct answer is \(correctAnswer)")"
//            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(vc, animated: true, completion: nil)
//            
//            //TODO: Popup instead of simple alert
////            let alert = UIAlertController(title: question.title,
////                                          message: "You answer was \(isCorrect ? "right" : "wrong")",
////                                          preferredStyle: .alert)
////            alert.addAction(UIAlertAction(title: "Ok, Whatever!", style: .default))
////
////            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(alert, animated: true)
//        } else {
//            switch response.actionIdentifier {
//            case ActionIdentifier.playNow.rawValue:
//                goToAnotherViewController(storyBoard: "Main", viewControllerIdentifier: "SecondVC")
//            case ActionIdentifier.remindMe.rawValue:
//                NotificationHandler.scheduleContestReminder()
//            case ActionIdentifier.playLater.rawValue:
//                print("Later pressed")
//            default:
//                print("other pressed")
//            }
//        }
    }
    
    func goToAnotherViewController(storyBoard: String, viewControllerIdentifier: String, isCorrectAnswer: Bool? = false) {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        
        if var rootViewController = keyWindow?.rootViewController {
            
            while let presentedViewController = rootViewController.presentedViewController {
                rootViewController = presentedViewController
            }
            
            let navigationController = rootViewController as? UINavigationController
            
            switch viewControllerIdentifier {
            case "SecondVC":
                let vcToLoad = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier) as! SecondVC
                vcToLoad.customTitle = "Play now pressed!"
                vcToLoad.view.backgroundColor = .green
                navigationController?.pushViewController(vcToLoad, animated: true)
            default:
                print("None")
            }
        }
    }
}
