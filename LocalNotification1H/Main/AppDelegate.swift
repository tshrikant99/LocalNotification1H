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
        print("Response: \(response)")
        
        switch response.actionIdentifier {
        case actionIdentiifier.playNow.rawValue:
            print("playNow pressed")
            
            let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

            if var rootViewController = keyWindow?.rootViewController {

                while let presentedViewController = rootViewController.presentedViewController {
                    rootViewController = presentedViewController
                }

                let navigationController = rootViewController as? UINavigationController

                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
                vc.customTitle = "Play now pressed!"
                vc.view.backgroundColor = .green
                navigationController?.pushViewController(vc, animated: true)
            }
        case actionIdentiifier.remindMe.rawValue:
            let notifyVC = NotificationVC()
            notifyVC.send1huddleNotification()
            print("remindMe pressed")
        case actionIdentiifier.playLater.rawValue:
            print("Later pressed")
        default:
            print("other pressed")
        }
        
    }
}
