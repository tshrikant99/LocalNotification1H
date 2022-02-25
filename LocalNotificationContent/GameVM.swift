//
//  NotificationCEVM.swift
//  LocalNotificationContent
//
//  Created by shrikant on 25/02/22.
//

import Foundation
import UIKit

class GameVM {
    typealias VoidHandler = ()->Void
    typealias AnswerHandler = (Int,Int)->Void
    
    var game: Game = Game(title: "", questions: [])
    
    var questionIndex = -1
    
    var errorHandler: VoidHandler?
    var questionDidUpdate: VoidHandler?
    var answerSelected: AnswerHandler?
    var gameDidComplete: VoidHandler?
    
    var question: Question { game.questions[questionIndex] }
    var nextButtonText: String { questionIndex < game.questions.count - 1 ? "Next" : "Done"}
    
    func setGame(data: Data) {
        do {
            self.game = try JSONDecoder().decode(Game.self, from: data)
            self.next()
        } catch {
            errorHandler?()
        }
    }
    
    func didSelectAnswer(at index: Int) {
        let correctIndex = question.answers.firstIndex { $0.isCorrect }!
        answerSelected?(index, correctIndex)
    }
    
    func next() {
        if questionIndex < game.questions.count - 1 {
            questionIndex += 1
            questionDidUpdate?()
        } else {
            gameDidComplete?()
        }
    }
}
