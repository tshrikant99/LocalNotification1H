//
//  ViewController.swift
//  LocalNotification1H
//
//  Created by shrikant on 14/12/21.
//

import UIKit
import UserNotifications

class NotificationVC: UIViewController {
    
    @IBOutlet weak var notifyButton: UIButton!
    
    let notifyAfter: TimeInterval = 8
    let notificationTitle = "1 Huddle"
    let notificationMessage = "Hey! A contest is ending today & you haven't played some games, Play now! so you don't miss out."
    let categoryIdentifier = "My category"
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        notifyButton.titleLabel?.text = "Notify after 8 sec"
        
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Error in request authorize \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func onNotifyPressed(_ sender: UIButton) {
        send1huddleNotification()
    }
    
    func send1huddleNotification() {
        let content = createNotificationContent(title: notificationTitle, message: notificationMessage)
        sendNotificationRequest(content: content, notifyAfter: notifyAfter)
        
        let playNowAction = getNotificationAction(title: "Play now!", actionIdentifier: .playNow, actionType: .foreground)
        let remindAction = getNotificationAction(title: "Remind me later", actionIdentifier: .remindMe, actionType: .destructive)
        let playLaterAction = getNotificationAction(title: "I'll Play later", actionIdentifier: .playLater, actionType: .destructive)
        addNotificationActions(customActions: playNowAction, remindAction, playLaterAction)
    }
    
    // Create content
    func createNotificationContent(title: String, message: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryIdentifier
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        return content
    }
    
    // Notification request
    func sendNotificationRequest(content: UNMutableNotificationContent, notifyAfter: TimeInterval) {
        
        // Add trigger
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: notifyAfter, repeats: false)
        
        let req = UNNotificationRequest.init(identifier: "Notify", content: content, trigger: trigger)
        
        notificationCenter.add(req) { error in
            if let error = error {
                print("Error in request notification \(error.localizedDescription)")
            }
        }
    }
    
    // Create action
    func getNotificationAction(title: String, actionIdentifier: actionIdentiifier, actionType: UNNotificationActionOptions) -> UNNotificationAction {
        let action = UNNotificationAction.init(identifier: actionIdentifier.rawValue, title: title, options: actionType)
        
        return action
    }
    
    // Add actions
    func addNotificationActions(customActions: UNNotificationAction...) {
        
        let category = UNNotificationCategory.init(identifier: categoryIdentifier, actions: customActions, intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
}

extension NotificationVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Response: \(response)")
        
        switch response.actionIdentifier {
        case actionIdentiifier.playNow.rawValue:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
            vc.customTitle = "\(actionIdentiifier.playNow.rawValue) Pressed"
            vc.view.backgroundColor = .green
            self.navigationController?.pushViewController(vc, animated: true)
        case actionIdentiifier.remindMe.rawValue:
            send1huddleNotification()
        case actionIdentiifier.playLater.rawValue:
            print("Later pressed")
        default:
            print("other pressed")
        }
        
    }
}

enum actionIdentiifier: String {
    case playNow = "play now"
    case remindMe = "remind me"
    case playLater = "play later"
}
