//
//  PopupVC.swift
//  LocalNotification1H
//
//  Created by shrikant on 12/01/22.
//

import UIKit

class PopupVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var buttonStack: UIStackView!
    
    var viewModel: PopupVM! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
        closeButton.layer.cornerRadius = closeButton.bounds.width/2
        closeButton.layer.masksToBounds = true
        
        headerView.layer.cornerRadius = 8
        headerView.layer.masksToBounds = true
        headerLabel.text = "Question"
        
        questionTitleLabel.text = viewModel.question.title
        
        if let urlString = viewModel.question.imageURL,
            let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        } else {
            imageViewHeight.constant = 0
            imageView.isHidden = true
        }
        
        buttons.enumerated().forEach { (idx, button) in
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            
            button.setTitle(viewModel.question.answers[idx].value, for: .normal)
        }
        
        if viewModel.attemptAnswer == false {
            guard let correctAnswerIndex = viewModel.question.answers.firstIndex( where: { $0.isCorrect })
            else { return }
            selectAnswer(at: correctAnswerIndex)
        }
    }
    
    private func selectAnswer(at index: Int) {
        guard let correctAnswerIndex = viewModel.question.answers.firstIndex( where: { $0.isCorrect })
        else { return }
        
        let selectedButton = buttons[index]
        
        if correctAnswerIndex == selectedButton.tag {
            selectedButton.backgroundColor = .green
        } else {
            let answerButton = buttons[correctAnswerIndex]
            answerButton.backgroundColor = .green
            
            selectedButton.backgroundColor = .red
        }
        
        buttonStack.isUserInteractionEnabled = false
    }
    
}

extension PopupVC {
    
    @IBAction func tapOnButton(_ sender: UIButton) {
        selectAnswer(at: sender.tag)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PopupVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Dismiss popup when touching main view i.e. outer view 
        if touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
            
    }
}
