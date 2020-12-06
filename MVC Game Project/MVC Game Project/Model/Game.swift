//
//  Game.swift
//  MVC Game Project
//
//  Created by PD Berlin01 on 26.06.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import Foundation
class Game {
    
    var myStats = Stats()
    var score = 0
    
    var questions = [Question]()
    var currentIndex = 0
    
    var state: State = .ongoing
    
    var questionsReady:  NSNotification.Name
    
    var notification: Notification
    
    enum State {
        case ongoing, over
    }
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    private func receiveQuestions(_ questions: [Question]) {
        self.questions = questions
        state = .ongoing
    }
    
    init(withNotificationName
        notificationName: String){
        questionsReady = Notification.Name(rawValue: notificationName)
        notification = Notification(name: self.questionsReady)
    }
    
    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            NotificationCenter.default.post(self.notification)
           
        }
    }
    
    func answerCurrentQuestion(with answer: Bool) {
        
        if currentQuestion.isCorrect == answer {
            score += 1
        }
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
        myStats.numberOfGames += 1
        myStats.scores.append(score)
	}
}
