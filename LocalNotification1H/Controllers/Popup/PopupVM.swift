//
//  PopupVM.swift
//  LocalNotification1H
//
//  Created by shrikant on 19/01/22.
//

import Foundation

struct PopupVM {
    
    var question: Question
    var attemptAnswer: Bool
    
    init(question: Question, isAttempt: Bool) {
        self.question = question
        self.attemptAnswer = isAttempt
    }
    
}
