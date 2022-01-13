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
        NotificationHandler.send1huddleNotification()
    }
    
    @IBAction func showQuestionPage(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
        vc.question = [.aExample, .bExample, .cExample].randomElement()!
        navigationController?.pushViewController(vc, animated: true)
    }
}

enum ActionIdentifier: String {
    case playNow = "play now"
    case remindMe = "remind me"
    case playLater = "play later"
}
