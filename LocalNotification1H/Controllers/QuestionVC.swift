//
//  QuestionVC.swift
//  LocalNotification1H
//
//  Created by shrikant on 06/01/22.
//

import UIKit

struct Question: Codable {
    struct AnswerOption: Codable {
        let value: String
        let isCorrect: Bool
    }
    
    var id: Int = UUID().hashValue
    let title: String
    let answers: [AnswerOption]
    let imageURL: String
}

class QuestionVC: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    
    var isReponseTrue: Bool = false
    var isAnswerdFromNotification: Bool = false
    
    var question: Question!
    
    let correctAnswerMsg: String = "Congratulations ;) Your answer is Correct"
    let inCorrectAnswerMsg: String = "Sorry! Your answer is Incorrect"
    
    @IBOutlet var buttons: [UIButton]!
    
    // TO DO : Download img from URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question.title
        // Do any additional setup after loading the view.
        
        setup()
        
        if isAnswerdFromNotification {
            var title = inCorrectAnswerMsg
            if isReponseTrue {
                title = correctAnswerMsg
            }
           let alert = UIAlertController.init(title: title, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            
            resetFlags()
        }
    }
    
    func setup() {
        buttons.enumerated().forEach { (idx, button) in
            button.setTitle(question.answers[idx].value, for: .normal)
        }
    }
    
    func resetFlags() {
        isAnswerdFromNotification = false
        isReponseTrue = false
    }
    
    @IBAction func answerQuestion(_ sender: UIButton) {
        let answerSelected = question.answers[sender.tag]
        
        if answerSelected.isCorrect == false {
            NotificationHandler.scheduleQuestionNotification(for: question)
        }
    }
}
