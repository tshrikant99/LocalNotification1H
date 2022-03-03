//
//  GameVC.swift
//  LocalNotificationContent
//
//  Created by shrikant on 03/02/22.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Lottie

class GameVC: UIViewController {
    @IBOutlet weak var friendsImageView: UIImageView!
    @IBOutlet weak var quizLabel: UILabel!
    
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet var optionViews: [UIView]!
    @IBOutlet var optionLabels: [UILabel]!
    @IBOutlet var optionImageViews: [UIImageView]!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    let viewModel = GameVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        setupUI()
        setupObservers()
    }
    
    func setupUI() {
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = true
        
        for view in optionViews {
            view.addShadow()
            view.layer.masksToBounds = false
            view.addCornerRadius()
        }
    }
    
    func setupObservers() {
        viewModel.questionDidUpdate = { [weak self] in
            guard let self = self else { return }
            
            self.quizLabel.text = self.viewModel.question.title
            self.nextButton.setTitle(self.viewModel.nextButtonText, for: .normal)
            self.nextButton.isHidden = true
            
            self.optionButtons.forEach {
                $0.alpha = 0
                $0.isEnabled = false
            }
            
            self.optionViews.forEach {
                $0.alpha = 0
            }
            
            self.optionLabels.forEach {
                $0.text = ""
                $0.textColor = .black
            }
            self.optionImageViews.forEach { $0.isHidden = true }
            
            for (index, answerOption) in self.viewModel.question.answers.enumerated() {
                let button = self.optionButtons[index]

                button.alpha = 1
                button.isEnabled = true
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                //button.setTitle(answerOption.value, for: .normal)
                
                self.optionLabels[index].text = answerOption.value
                
                self.optionViews[index].alpha = 1
            }
            
            if let imageURL = self.viewModel.question.imageURL {
                getImageFromUrl(url: imageURL) { image in
                    DispatchQueue.main.async {
                        self.imageHeightConstraint.constant = 180
                        self.friendsImageView.image = image
                    }
                }
            } else {
                self.imageHeightConstraint.constant = 0
                self.friendsImageView.image = nil
            }
            
        }
        
        viewModel.answerSelected = { [weak self] (userIndex, correctIndex) in
            guard let self = self else { return }
            
            self.optionButtons[correctIndex].backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.optionButtons[correctIndex].setTitleColor(.white, for: .normal)

            self.optionImageViews[correctIndex].image = #imageLiteral(resourceName: "checkmark-plain")
            self.optionImageViews[correctIndex].isHidden = false
            self.optionImageViews[correctIndex].tintColor = .white
            
            self.optionLabels[correctIndex].textColor = .white
            
            if userIndex != correctIndex {
                self.optionButtons[userIndex].backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.optionButtons[userIndex].setTitleColor(.white, for: .normal)
                
                self.optionImageViews[userIndex].image = #imageLiteral(resourceName: "close")
                self.optionImageViews[userIndex].tintColor = .white
                self.optionImageViews[userIndex].isHidden = false
                
                self.optionLabels[userIndex].textColor = .white
            }

            self.optionButtons.forEach { $0.isEnabled = false }
            self.nextButton.isHidden = false
        }
        
        viewModel.gameDidComplete = { [weak self] in
            guard let self = self else { return }
            
            let vc = UIViewController()

            vc.view.backgroundColor = .white
            vc.modalPresentationStyle = .custom

            let animationView = AnimationView(name: "animation-congrats")
            animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            animationView.center = vc.view.center
            animationView.contentMode = .scaleToFill
            animationView.backgroundBehavior = .pauseAndRestore

            vc.view.addSubview(animationView)
            animationView.play()

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
