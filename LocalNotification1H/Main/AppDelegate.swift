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
            let questionData = response.notification.request.content.userInfo["data"] as! Data
            let question = try! JSONDecoder().decode(Question.self, from: questionData)
            
            switch actionIdentifier {
            case .attemptAnswer:
                print("show popup with question content & 4 answer options that are functional")
                showQuestionPopup(wantsToAttempt: true, question: question)
            case .showAnswer:
                print("show popup with question content & 4 answer options with the correct answer already highlighted")
                showQuestionPopup(wantsToAttempt: false, question: question)
            case .ignore:
                print("do nothing")
            }
        }
    }
    
    func showQuestionPopup(wantsToAttempt: Bool, question: Question) {
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
        vc.viewModel = PopupVM(question: question, isAttempt: wantsToAttempt)
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(vc, animated: true, completion: nil)
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
