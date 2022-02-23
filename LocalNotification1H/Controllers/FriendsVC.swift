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
    }
    

    @IBAction func guessCharacter(_ sender: UIButton) {
        //TODO: - Use UNUserNotificationCenterManager, & call Notification Handler method to schedule
        NotificationHandler.scheduleMCQNotification(for: .friendsGame)
    }
}

