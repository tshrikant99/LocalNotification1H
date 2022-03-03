//
//  ViewController.swift
//  LocalNotification1H
//
//  Created by shrikant on 14/12/21.
//

import UIKit

class NotificationVC: UIViewController {
    @IBOutlet weak var notifyButton: UIButton!
    
    @IBAction func onNotifyPressed(_ sender: UIButton) {
        NotificationHandler.scheduleContestReminder()
    }
    
    @IBAction func showGifNotification(_ sender: UIButton) {
        let gifURL = "https://i.pinimg.com/originals/fe/df/71/fedf7125acf620e856b6d09ef44eee51.gif"
        NotificationHandler.showGifNotification(gifURL: gifURL)
    }
    
    @IBAction func showQuestionPage(_ sender: Any) {
        NotificationHandler.scheduleNotification(for: Game.aExample)
    }
}
