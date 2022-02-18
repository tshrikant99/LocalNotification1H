//
//  NotificationViewController.swift
//  LocalNotificationContent
//
//  Created by shrikant on 03/02/22.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var friendsImageView: UIImageView!
    
    @IBOutlet weak var quizLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    @IBAction func onClickNotificationButton(_ sender: UIButton) {
        print(" Image onClickNotificationButton")
        
        let session = URLSession.shared
        
        if let imageUrl = URL(string: "https://www.filmcompanion.in/wp-content/uploads/2020/08/Film-companion-ross-friends-lead-image-2.jpg") {
            session.dataTask(with: URLRequest(url: imageUrl)) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async { [weak self] in
                        self?.friendsImageView.image = UIImage(data: data)
                    }
                    
                } else {
                    print(" Image not downloaded")
                    self.friendsImageView.image = UIImage(named: "ross")
                }
            }.resume()
        } else {
            print(" Image not downloaded 2")
            friendsImageView.image = UIImage(named: "ross")
        }
        
        quizLabel.text = "Thats not the right answer, have you watched friends before?"
    }
    
    
    func didReceive(_ notification: UNNotification) {
        print("didReceive notification")
        quizLabel.text = "Can you guess this character from friends?"
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        print("didReceive response")
        
        if response.actionIdentifier == "joey" {
            friendsImageView.image = UIImage(named: "joey")
            quizLabel.text = "Yoo. Thats the right answer man!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                completion(.dismissAndForwardAction)
            }
        } else if response.actionIdentifier == "ross" {
            
            let session = URLSession.shared
            
            if let imageUrl = URL(string: "https://www.filmcompanion.in/wp-content/uploads/2020/08/Film-companion-ross-friends-lead-image-2.jpg") {
                session.dataTask(with: URLRequest(url: imageUrl)) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async { [weak self] in
                            self?.friendsImageView.image = UIImage(data: data)
                        }
                        
                    } else {
                        print(" Image not downloaded")
                        self.friendsImageView.image = UIImage(named: "ross")
                    }
                }.resume()
            } else {
                print(" Image not downloaded 2")
                friendsImageView.image = UIImage(named: "ross")
            }
            
            quizLabel.text = "Thats not the right answer, have you watched friends before?"
            completion(.doNotDismiss)
        } else if response.actionIdentifier == "chandler" {
            friendsImageView.image = UIImage(named: "chandler")
            quizLabel.text = "Are you kidding me, please recall your memory!"
            completion(.doNotDismiss)
        }
    }
}
