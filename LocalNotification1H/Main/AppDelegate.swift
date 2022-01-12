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
        if response.actionIdentifier.hasPrefix("Answer|") {
            let questionData = response.notification.request.content.userInfo["data"] as! Data
            let question = try! JSONDecoder().decode(Question.self, from: questionData)
            
            let isCorrect: Bool = {
                let selectedAnswer = response.actionIdentifier.split(separator: "|").last!
                let correctAnswer = question.answers.first { $0.isCorrect }!.value
                
                return selectedAnswer == correctAnswer
            }()
            
            //TODO: Popup instead of simple alert
            let alert = UIAlertController(title: question.title,
                                          message: "You answer was \(isCorrect ? "right" : "wrong")",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok, Whatever!", style: .default))
            
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(alert, animated: true)
        } else {
            switch response.actionIdentifier {
            case ActionIdentifier.playNow.rawValue:
                goToAnotherViewController(storyBoard: "Main", viewControllerIdentifier: "SecondVC")
            case ActionIdentifier.remindMe.rawValue:
                NotificationHandler.send1huddleNotification()
            case ActionIdentifier.playLater.rawValue:
                print("Later pressed")
            default:
                print("other pressed")
            }
        }
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
