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
    
    let notificationHandler = NotificationHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        notifyButton.titleLabel?.text = "Notify after \(Int(notificationHandler.notifyAfter)) sec"
        
        notificationHandler.requestAuthorization()
    }
    
    @IBAction func onNotifyPressed(_ sender: UIButton) {
        notificationHandler.send1huddleNotification()
    }
    
}

enum actionIdentiifier: String {
    case playNow = "play now"
    case remindMe = "remind me"
    case playLater = "play later"
}
