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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onNotifyPressed(_ sender: UIButton) {
        NotificationHandler.scheduleContestReminder()
    }
    
    @IBAction func showGifNotification(_ sender: UIButton) {
        let gifURL = "https://i.pinimg.com/originals/fe/df/71/fedf7125acf620e856b6d09ef44eee51.gif"
        NotificationHandler.showGifNotification(gifURL: gifURL)
    }
    
    @IBAction func showVideoNotificaion(_ sender: UIButton) {
        let videoUrlString = "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4"
        NotificationHandler.showVideoNotification(videoUrlString: videoUrlString)
    }
    
    @IBAction func showQuestionPage(_ sender: Any) {
        NotificationHandler.scheduleMCQNotification(for: .aExample)
    }
}

extension UNNotificationCategory {
    
    enum CustomKeys: String {
        case contest
        case question
        case mcq
    }
    
}

extension UNNotificationAction {
    
    enum ContestActions: String {
        case playNow
        case remindMeLater
        case ignore
        
        var title: String {
            switch self {
            case .playNow       : return "Play Now"
            case .remindMeLater : return "Remind me later"
            case .ignore        : return "Don't remind me"
            }
        }
    }
    
    enum QuestionActions: String {
        case attemptAnswer
        case showAnswer
        case ignore
        
        var title: String {
            switch self {
            case .attemptAnswer : return "Attempt" //open app & show a popup with the question & 4 options
            case .showAnswer    : return "Show Answer" //open app & show popup with the answer
            case .ignore        : return "Don't remind me"
            }
        }
    }
    
}
