//
//  NotificationViewController.swift
//  LocalNotificationContent
//
//  Created by shrikant on 03/02/22.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

    @IBOutlet weak var friendsImageView: UIImageView!
    
    @IBOutlet weak var quizLabel: UILabel!
    
    @IBOutlet var options: [UIButton]!
    
    @IBOutlet weak var nextButton: UIButton!
    
    let session = URLSession.shared
    
    var currentQuiz: NotificationData = .friendsJoeyQuestionData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        loadQuestion(data: currentQuiz)
    }
    
    func loadQuestion(data: NotificationData) {
     
        DispatchQueue.main.async {
            self.quizLabel.text = data.subTitle
        }
        
        DispatchQueue.main.async {
            for (index, option) in self.options.enumerated() {
                option.backgroundColor = .gray
                option.setTitle(data.options[index].title, for: .normal)
            }
        }
        
        downloadImageFromUrl(url: data.imageUrl) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.friendsImageView.image = image
                }
            }
        }
    }
    
    @IBAction func onClickNotificationButton(_ sender: UIButton) {
        
        friendsImageView.isHidden = false
        
        DispatchQueue.main.async {
            for opt in self.options {
                opt.backgroundColor = .gray
            }
        }
        
        let imageUrl = currentQuiz.options[sender.tag].optionImageUrl
        
        var correctAnswerIndex = 0

        for (index, opt) in currentQuiz.options.enumerated() {
            if opt.isAnswerCorrect {
                correctAnswerIndex = index
            }
        }

        downloadImageFromUrl(url: imageUrl, completion: { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.friendsImageView.image = image
                }
            }
        })
        
        DispatchQueue.main.async {
            self.quizLabel.text = self.currentQuiz.options[sender.tag].answerMessage

            switch sender.tag {
            case correctAnswerIndex:
                sender.backgroundColor = .green
            default:
                sender.backgroundColor = .red
            }
        }
    }
    
    @IBAction func goNextQuestion(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.nextButton.isHidden = true
            self.currentQuiz = .friendsPhoebeQuestionData
            self.loadQuestion(data: .friendsPhoebeQuestionData)
        }
    }
}

extension NotificationViewController {
    func downloadImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void ) {
        if let imageUrl = URL(string: url) {
            session.dataTask(with: URLRequest(url: imageUrl)) { data, response, error in
                if let data = data {
                    completion(UIImage(data: data))
                } else {
                    print(" Image not downloaded")
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
}

extension NotificationViewController: UNNotificationContentExtension {
    func didReceive(_ notification: UNNotification) {
        print("didReceive notification")
        quizLabel.text = "Can you guess this character from friends?"
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        print("didReceive response")
    }
}
