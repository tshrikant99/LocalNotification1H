//
//  ViewController.swift
//  LocalNotification1H
//
//  Created by shrikant on 14/12/21.
//

import UIKit
import UserNotifications

class NotificationVC: UIViewController , UNUserNotificationCenterDelegate {

    @IBOutlet weak var notifyButton: UIButton!
    
    let notifyAfter: TimeInterval = 5
    let notificationTitle = "Hey there"
    let notificationMessage = "Good evening"
    let categoryIdentifier = "My category"
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        notifyButton.titleLabel?.text = "Notify after \(Int(notifyAfter)) sec"
        
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Error in request authorize \(error.localizedDescription)")
            }
        }
    }

    @IBAction func onNotifyPressed(_ sender: UIButton) {
        // Add content
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryIdentifier
        content.title = notificationTitle
        content.body = notificationMessage
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        // Add trigger
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: notifyAfter, repeats: false)
        
        let identifier = "Notify"
        
        // Notification request
        let req = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(req) { error in
            if let error = error {
                print("Error in request notification \(error.localizedDescription)")
            }
        }
        
        addActions(identifier: categoryIdentifier)
    }
    
    // Add actions
    func addActions(identifier: String) {
        let action1 = UNNotificationAction.init(identifier: "Like", title: "Like", options: .foreground)
        let action2 = UNNotificationAction.init(identifier: "Dislike", title: "Dislike", options: .destructive)
        
        let category = UNNotificationCategory.init(identifier: identifier, actions: [action1, action2], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

