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
        // Do any additional setup after loading the view.
        
        notifyButton.titleLabel?.text = "Notify after 8 sec"
    }
    
    @IBAction func onNotifyPressed(_ sender: UIButton) {
        NotificationHandler.scheduleContestReminder()
    }
    
    @IBAction func showQuestionPage(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
        vc.question = [.aExample, .bExample, .cExample, .dExample, .eExample].randomElement()!
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UNNotificationCategory {
    
    enum CustomKeys: String {
        case contest
        case question
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
