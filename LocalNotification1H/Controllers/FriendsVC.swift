//
//  FriendsVC.swift
//  LocalNotification1H
//
//  Created by shrikant on 02/02/22.
//

import UIKit

class FriendsVC: UIViewController {

    @IBOutlet weak var friendsImageView: UIImageView!
    
    let categoryIdentifier = "friendsQuizCategory"
    let reuestIdentifier = "friendsQuiz"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().delegate = self
    }
    

    @IBAction func guessCharacter(_ sender: UIButton) {
        
        let friendsNotificationContent = UNMutableNotificationContent()
        friendsNotificationContent.title = "Friends Quiz"
        friendsNotificationContent.subtitle = "Do you know him?"
        
        friendsNotificationContent.categoryIdentifier = categoryIdentifier
        
        let request = UNNotificationRequest(identifier: reuestIdentifier, content: friendsNotificationContent, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false))
        
        UNUserNotificationCenter.current().add(request) { err in
            if let error = err {
                print(error.localizedDescription)
            }
            
        }
    }
}

extension FriendsVC : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}
