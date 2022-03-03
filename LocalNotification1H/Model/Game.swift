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
    let title: String
    let correctIndex: Int
    let answerOptions: [String]
    let imageURL: String?
}

extension Game {
    
    static let aExample = Game(title: "Win as One",
                               questions: [
                                .init(title: "What does the 'O' stand for?",
                                      correctIndex: 1,
                                      answerOptions: [
                                        "Our Way",
                                        "Our Job",
                                        "One Win",
                                        "Opportunity"
                                      ],
                                      imageURL: "https://1huddle-prod.s3.us-west-2.amazonaws.com/production/1huddle/company/questions/646323_image.jpg"),
                                .init(title: "What does the 'N' stand for?",
                                      correctIndex: 2,
                                      answerOptions: [
                                        "Never Quit",
                                        "Next Play",
                                        "Newark",
                                        "Next Step"
                                      ],
                                      imageURL: "https://1huddle-prod.s3.us-west-2.amazonaws.com/production/1huddle/company/questions/646322_image.jpg"),
                                .init(title: "What does the 'E' stand for?",
                                      correctIndex: 2,
                                      answerOptions: [
                                        "Extra Energy",
                                        "Extra Effort",
                                      ],
                                      imageURL: "https://1huddle-prod.s3.us-west-2.amazonaws.com/production/1huddle/company/questions/646321_image.jpg")
                               ])
    
}
