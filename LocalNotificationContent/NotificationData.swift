//
//  NotificationData.swift
//  LocalNotificationContent
//
//  Created by shrikant on 22/02/22.
//

import Foundation

struct NotificationData {
    
    let title: String
    let subTitle: String
    let imageUrl: String
    
    let options: [NotificationOptions]
    
    static var friendsJoeyQuestionData: Self { .init(title: "Friends Quiz",
                                                     subTitle: "Do you know this character?",
                                                     imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuB9CxUmQrZGljwWQj539W-AnBuc71XU-pxA&usqp=CAU.jpg",
                                                     options: [.init(title: "Ross",
                                                                     isAnswerCorrect: false,
                                                                     optionImageUrl: "https://www.filmcompanion.in/wp-content/uploads/2020/08/Film-companion-ross-friends-lead-image-2.jpg",
                                                                     answerMessage: "Thats not the right answer, have you watched friends before?"),
                                                               
                                                                .init(title: "Chandler",
                                                                      isAnswerCorrect: false,
                                                                      optionImageUrl: "https://staticg.sportskeeda.com/editor/2022/01/02fa5-16417541468338-1920.jpg",
                                                                      answerMessage: "Are you kidding me, please recall your memory!"),
                                                               .init(title: "Joey",
                                                                     isAnswerCorrect: true,
                                                                     optionImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWkTnl1DWti753dIFWFR6SLEBWxp4HWND_qA&usqp=CAU.jpg",
                                                                     answerMessage: "Yoo. Thats the right answer man!"),
                                                               .init(title: "None",
                                                                     isAnswerCorrect: false,
                                                                     optionImageUrl: "https://img.etimg.com/thumb/msid-88143081,width-640,resizemode-4,imgsize-11132/you-are-fired.jpg",
                                                                     answerMessage: "You are fired!")])}
    
    
    static var friendsPhoebeQuestionData: Self { .init(title: "Friends Quiz",
                                                     subTitle: "Who is this girl?",
                                                     imageUrl: "https://static01.nyt.com/images/2019/09/08/arts/08friends-phoebe6/08friends-phoebe6-jumbo.jpg",
                                                     options: [.init(title: "Monika",
                                                                     isAnswerCorrect: false,
                                                                     optionImageUrl: "https://img.mensxp.com/media/content/2019/Jul/decoding-lsquo-friends-rsquo-1200-1562335930.jpg?w=414&h=276&cc=1.jpg",
                                                                     answerMessage: "No, you cant do this.!"),
                                                               
                                                                .init(title: "Phoebe",
                                                                      isAnswerCorrect: true,
                                                                      optionImageUrl: "https://cdn.onebauer.media/one/media/601c/13ba/a71b/7967/074a/deb1/Phoebe2.png?format=jpg&quality=80&width=440&ratio=16-9&resize=aspectfill.jpg",
                                                                      answerMessage: "Aha, Thats it! Kudos"),
                                                               .init(title: "Rachel",
                                                                     isAnswerCorrect: false,
                                                                     optionImageUrl: "https://images.firstpost.com/wp-content/uploads/large_file_plugin/2021/02/1614241148_rachelgreen640.jpg",
                                                                     answerMessage: "I'm Calling to your memory"),
                                                               .init(title: "None",
                                                                     isAnswerCorrect: false,
                                                                     optionImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVSQxMhUtkeFySKqdLObtxtY-315O-3OWwMQ&usqp=CAU.jpg",
                                                                     answerMessage: "Next time!")])}
}

struct NotificationOptions {
    let title: String
    let isAnswerCorrect: Bool
    let optionImageUrl: String
    let answerMessage: String
}

