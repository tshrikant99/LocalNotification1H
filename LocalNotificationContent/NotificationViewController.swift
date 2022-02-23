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
    
    var game: Game = Game(title: "", questions: [])
    var currentQuiz: Question = Question(title: "", answers: [])
    
    var gameLevel: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func loadGame() {
        
        currentQuiz = game.questions[gameLevel]
        
        DispatchQueue.main.async {
            self.quizLabel.text = self.currentQuiz.title
        }
        
        DispatchQueue.main.async {
            for (index, option) in self.options.enumerated() {
                option.backgroundColor = .gray
                option.setTitle(self.currentQuiz.answers[index].value, for: .normal)
            }
        }
        
        if let imageUrl = currentQuiz.imageURL {
            getImageFromUrl(url: imageUrl) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.friendsImageView.image = image
                    }
                }
            }
        }
    }
    
    @IBAction func onClickNotificationButton(_ sender: UIButton) {
        var correctAnswerIndex = 0

        for (index, opt) in currentQuiz.answers.enumerated() {
            if opt.isCorrect {
                correctAnswerIndex = index
            }
        }
        
        DispatchQueue.main.async {
            for opt in self.options {
                opt.backgroundColor = .gray
            }
        }
        
        DispatchQueue.main.async {
            switch sender.tag {
            case correctAnswerIndex:
                sender.backgroundColor = .green
            default:
                sender.backgroundColor = .red
            }
        }
    }
    
    func loadNextQuiz() {
        if gameLevel < game.questions.count-1 {
            gameLevel += 1
            loadGame()
        } else {
            self.nextButton.isHidden = true
        }
    }
    
    @IBAction func goNextQuestion(_ sender: UIButton) {
        loadNextQuiz()
    }
}

extension NotificationViewController: UNNotificationContentExtension {
    func didReceive(_ notification: UNNotification) {
        do {
            let gameData = notification.request.content.userInfo["data"] as! Data
            let game = try JSONDecoder().decode(Game.self, from: gameData)
            
            self.game = game
            loadGame()
        } catch {
            print(error.localizedDescription)
        }
        
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        completion(.doNotDismiss)
    }
}
