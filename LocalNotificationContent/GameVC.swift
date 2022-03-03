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

struct AnswerOptionElements {
    weak var view: UIView?
    weak var label: UILabel?
    weak var imageView: UIImageView?
}

class GameVC: UIViewController {
    @IBOutlet weak var friendsImageView: UIImageView!
    @IBOutlet weak var quizLabel: UILabel!
    
    @IBOutlet var optionView1: UIView!
    @IBOutlet var optionView2: UIView!
    @IBOutlet var optionView3: UIView!
    @IBOutlet var optionView4: UIView!
    
    @IBOutlet var optionTitleLabel1: UILabel!
    @IBOutlet var optionTitleLabel2: UILabel!
    @IBOutlet var optionTitleLabel3: UILabel!
    @IBOutlet var optionTitleLabel4: UILabel!
    
    @IBOutlet var optionImageView1: UIImageView!
    @IBOutlet var optionImageView2: UIImageView!
    @IBOutlet var optionImageView3: UIImageView!
    @IBOutlet var optionImageView4: UIImageView!
    
    var optionElements: [AnswerOptionElements] {
        [.init(view: optionView1, label: optionTitleLabel1, imageView: optionImageView1),
         .init(view: optionView2, label: optionTitleLabel2, imageView: optionImageView2),
         .init(view: optionView3, label: optionTitleLabel3, imageView: optionImageView3),
         .init(view: optionView4, label: optionTitleLabel4, imageView: optionImageView4)
        ]
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    let viewModel = GameVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
    }
    
    func setupUI() {
        for element in optionElements {
            element.view?.addShadow()
            element.view?.layer.masksToBounds = false
            element.view?.addCornerRadius()
        }
    }
    
    func setupObservers() {
        viewModel.questionDidUpdate = { [weak self] in
            guard let self = self else { return }
            
            self.updateQuestionContent()
            self.updateAnswerOptions()
            self.updateQuestionImage()
        }
        
        viewModel.answerSelected = { [weak self] (userIndex, correctIndex) in
            guard let self = self else { return }
            
            self.optionElements.forEach {
                $0.view?.isUserInteractionEnabled = false
            }
            
            let correctOption = self.optionElements[correctIndex]
            correctOption.view?.backgroundColor = .green
            correctOption.label?.textColor = .white

            correctOption.imageView?.image = UIImage(named: "answer-correct")
            correctOption.imageView?.isHidden = false
            correctOption.imageView?.tintColor = .white
            
            correctOption.label?.textColor = .white
            
            if userIndex != correctIndex {
                let incorrectOption = self.optionElements[userIndex]
                incorrectOption.view?.backgroundColor = .red
                incorrectOption.label?.textColor = .white
                
                incorrectOption.imageView?.image = UIImage(named: "answer-incorrect")
                incorrectOption.imageView?.tintColor = .white
                incorrectOption.imageView?.isHidden = false
                
                incorrectOption.label?.textColor = .white
            }

            self.nextButton.tintColor = .blue
            self.nextButton.isUserInteractionEnabled = true
        }
        
        viewModel.gameDidComplete = { [weak self] in
            guard let self = self else { return }
            
            let vc = UIViewController()
            vc.view.backgroundColor = .white

            let animationView = AnimationView(name: "animation-congrats")
            animationView.contentMode = .scaleToFill
            animationView.backgroundBehavior = .pauseAndRestore
            animationView.loopMode = .loop
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            vc.view.addSubview(animationView)
            
            NSLayoutConstraint.activate([
                animationView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
                animationView.heightAnchor.constraint(equalToConstant: 256),
                animationView.widthAnchor.constraint(equalToConstant: 256)
            ])
            
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: false)
            
            animationView.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.extensionContext?.dismissNotificationContentExtension()
            }
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

extension GameVC {
    func updateQuestionContent() {
        self.quizLabel.text = self.viewModel.question.title
        
        self.nextButton.setTitle(self.viewModel.nextButtonText, for: .normal)
        self.nextButton.tintColor = .gray
        self.nextButton.isUserInteractionEnabled = false
    }
    
    func resetAnswerOptions() {
        (0..<self.optionElements.count).forEach { (index) in
            self.optionElements[index].view?.isHidden = true
            
            self.optionElements[index].label?.text = nil
            self.optionElements[index].label?.textColor = .black
            
            self.optionElements[index].imageView?.isHidden = true
        }
    }
    
    func updateAnswerOptions() {
        resetAnswerOptions()
        
        for (index, answerOption) in self.viewModel.question.answerOptions.enumerated() {
            self.optionElements[index].view?.isUserInteractionEnabled = true
            self.optionElements[index].view?.isHidden = false
            self.optionElements[index].view?.backgroundColor = .white
            
            self.optionElements[index].label?.text = answerOption
            self.optionElements[index].label?.textColor = .black
        }
    }
    
    func updateQuestionImage() {
        self.friendsImageView.image = nil
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
}
