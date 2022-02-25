//
//  GameVC.swift
//  LocalNotificationContent
//
//  Created by shrikant on 03/02/22.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class GameVC: UIViewController {
    @IBOutlet weak var friendsImageView: UIImageView!
    @IBOutlet weak var quizLabel: UILabel!
    @IBOutlet var options: [UIButton]!
    @IBOutlet weak var nextButton: UIButton!
    
    let viewModel = GameVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        setupObservers()
    }
    
    func setupObservers() {
        viewModel.questionDidUpdate = { [weak self] in
            guard let self = self else { return }
            
            self.quizLabel.text = self.viewModel.question.title
            self.nextButton.setTitle(self.viewModel.nextButtonText, for: .normal)
            self.nextButton.isEnabled = false
            
            self.options.forEach { $0.isHidden = true }
            for (index, answerOption) in self.viewModel.question.answers.enumerated() {
                let button = self.options[index]
                
                button.isHidden = false
                button.isEnabled = true
                button.backgroundColor = .gray
                button.setTitleColor(.white, for: .normal)
                button.setTitle(answerOption.value, for: .normal)
            }
            
            if let imageURL = self.viewModel.question.imageURL {
                getImageFromUrl(url: imageURL) { image in
                    DispatchQueue.main.async {
                        self.friendsImageView.image = image
                    }
                }
            } else {
                self.friendsImageView.image = nil
            }
        }
        
        viewModel.answerSelected = { [weak self] (userIndex, correctIndex) in
            guard let self = self else { return }
            
            self.options[correctIndex].backgroundColor = .green
            self.options[correctIndex].setTitleColor(.black, for: .normal)
            
            if userIndex != correctIndex {
                self.options[userIndex].backgroundColor = .red
                self.options[userIndex].setTitleColor(.black, for: .normal)
            }
            
            self.options.forEach { $0.isEnabled = false }
            self.nextButton.isEnabled = true
        }
        
        viewModel.gameDidComplete = { [weak self] in
            guard let self = self else { return }
            
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: false)
        }
        
        viewModel.errorHandler = {
            //programmatically clear the notification
            print("unable to load game, dismiss quick")
        }
    }

    @IBAction func onClickNotificationButton(_ sender: UIButton) {
        viewModel.didSelectAnswer(at: sender.tag)
    }

    @IBAction func goNextQuestion(_ sender: UIButton) {
        viewModel.next()
    }
    
}

extension GameVC: UNNotificationContentExtension {
    func didReceive(_ notification: UNNotification) {
        guard let gameData = notification.request.content.userInfo["data"] as? Data else { return }
        viewModel.setGame(data: gameData)
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        completion(.doNotDismiss)
    }
}
