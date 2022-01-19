//
//  PopupVC.swift
//  LocalNotification1H
//
//  Created by shrikant on 12/01/22.
//

import UIKit

class PopupVC: UIViewController {

    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    var viewModel: PopupVM! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        
        popupTitle.text = viewModel.question.title
        answerLabel.isHidden = viewModel.attemptAnswer
        
        if viewModel.attemptAnswer {
            buttons.enumerated().forEach { (idx, button) in
                button.setTitle(viewModel.question.answers[idx].value, for: .normal)
            }
        } else {
            answerLabel.text = viewModel.question.answers.first { $0.isCorrect }!.value
            
            buttons.forEach { button in
                button.isHidden = true
            }
        }
    }
    
    @IBAction func tapOnButton(_ sender: UIButton) {
        let answerTag = viewModel.question.answers[sender.tag]
        if answerTag.isCorrect {
            sender.backgroundColor = .green
        } else {
            sender.backgroundColor = .red
        }
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
