//
//  NotificationData.swift
//  LocalNotificationContent
//
//  Created by shrikant on 22/02/22.
//

import Foundation

struct Game: Codable {
    let title: String
    let questions: [Question]
}

struct Question: Codable {
    struct AnswerOption: Codable {
        let value: String
        let isCorrect: Bool
    }
    
    var id: Int
    let title: String
    let answers: [AnswerOption]
    let imageURL: String?
    
    internal init(id: Int = UUID().hashValue, title: String, answers: [Question.AnswerOption], imageURL: String? = nil) {
        self.id = id
        self.title = title
        self.answers = answers
        self.imageURL = imageURL
    }
}

extension Question {
    
    static var aExample: Self { .init(title: "How many core values & standards make up the 1?",
                                      answers: [
                                        .init(value: "16", isCorrect: true),
                                        .init(value: "17", isCorrect: false),
                                        .init(value: "10", isCorrect: false),
                                        .init(value: "12", isCorrect: false)
                                      ].shuffled(),
                                      imageURL: "https://robohash.org/aExample.png?set=set1&size=200x200") }
    
    static var bExample: Self { .init(title: "What is 2 + 2?",
                                      answers: [
                                        .init(value: "4", isCorrect: true),
                                        .init(value: "1", isCorrect: false),
                                        .init(value: "3", isCorrect: false),
                                        .init(value: "22", isCorrect: false),
                                      ].shuffled(),
                                      imageURL: "https://robohash.org/bExample.png?set=set2&size=200x200") }
    
    static var cExample: Self { .init(title: "Which of these is not a browser?",
                                      answers: [
                                        .init(value: "Twitter", isCorrect: true),
                                        .init(value: "Firefox", isCorrect: false),
                                        .init(value: "Google Chrome", isCorrect: false),
                                        .init(value: "Opera", isCorrect: false),
                                      ].shuffled(),
                                      imageURL: "https://robohash.org/cExample.png?set=set3&size=200x200") }
    
    static var dExample: Self { .init(title: "What is 2 * 2?",
                                      answers: [
                                        .init(value: "4", isCorrect: true),
                                        .init(value: "16", isCorrect: false),
                                        .init(value: "0", isCorrect: false),
                                        .init(value: "-1", isCorrect: false)
                                      ].shuffled()) }
    
    static var eExample: Self { .init(title: "This is not an OS",
                                      answers: [
                                        .init(value: "Amazon", isCorrect: true),
                                        .init(value: "Android", isCorrect: false),
                                        .init(value: "iOS", isCorrect: false),
                                        .init(value: "Windows", isCorrect: false),
                                      ].shuffled()) }
    
}

extension Game {
    static var friendsGame: Self {.init(title: "Friends Quiz", questions: [.init(title: "Do you know him?",
                                                                                     answers: [.init(value: "Ross", isCorrect: false),
                                                                                               .init(value: "Chandler", isCorrect: false),
                                                                                               .init(value: "Joey", isCorrect: true),
                                                                                               .init(value: "None", isCorrect: false)], imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuB9CxUmQrZGljwWQj539W-AnBuc71XU-pxA&usqp=CAU.jpg"),
                                                                               .init(title: "Who's this girl?",
                                                                                     answers: [.init(value: "Monika", isCorrect: false),
                                                                                .init(value: "Phoebe", isCorrect: true),
                                                                                .init(value: "Rachel", isCorrect: false),
                                                                                .init(value: "Dont know", isCorrect: false)],
                                                                                     imageURL: "https://cdn.onebauer.media/one/media/601c/13ba/a71b/7967/074a/deb1/Phoebe2.png?format=jpg&quality=80&width=440&ratio=16-9&resize=aspectfill.jpg")])}
}
