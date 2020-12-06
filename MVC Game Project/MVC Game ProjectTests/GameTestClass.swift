//
//  GameTests.swift
//  MVC Game ProjectTests
//
//  Created by PD Berlin01 on 24.07.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import XCTest
@testable import MVC_Game_Project

class GameTests: XCTestCase {
    
    var game : Game!
    
    
    override func setUp() {
        super.setUp()
        game = Game(withNotificationName: "questionsLoaded")
        let questions = [Question(title: "The capital of Canada is Ottawa", isCorrect: true), Question(title: "The capital of America is Helsinki", isCorrect: false)]
        game.questions = questions
    }

    
    
    func testGivenThatCurrentScoreIsNil_WhenPlayerHasAnsweredFirstQuestionCorrectly_ThenTheGameIncrementsScoreToOne() {
        game.answerCurrentQuestion(with: true)
        XCTAssertEqual(1, game.score)
       
    }
    
    func testGivenThatCurrentScoreIsOne_WhenPlayerHasAnsweredCorrectlyAgain_ThenTheGameIncrementsScoreToTwo() {
           
           game.score = 1
           game.answerCurrentQuestion(with: true)
           XCTAssertEqual(2, game.score)
          
       }
    
    
    func testGivenThatQuestionViewReceivedNewQuestion_WhenPlayerHasAnsweredWithFalse_ThenTheGameDoesNotIncrementsScore() {
        
        game.answerCurrentQuestion(with: false)
        XCTAssertEqual(0, game.score)
       
    }
    
    func testGivenThatGameIsOver_WhenPlayerTapsNewGameButton_ThenTheGameIsRefreshedAndStartsOver() {
        
        
        let ViewController = UIStoryboard(name: "Main", bundle: Bundle.main)
        .instantiateViewController(identifier: "ViewController") as! GameViewController
        let _ = ViewController.view
        ViewController.game = game
        
        
        ViewController.didTapNewGameButton()
        
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.currentIndex, 0)
        
    }
    
    func testGivenThatPlayerHasAnsweredAQuestionCorrectly_WhenGameIsNotOver_ThenGameLoadsTheNextQuestion() {
        
        game.answerCurrentQuestion(with: true)
        XCTAssertEqual(game.state, .ongoing)
    }
    
    func testGivenThatPlayerHasAnsweredAQuestionIncorrrectly_WhenGameIsNotOver_ThenGameLoadsTheNextQuestion() {
        
        game.answerCurrentQuestion(with: false)
        XCTAssertEqual(game.state, .ongoing)
    }
   
    func testGivenThatGameHasBeenOngoing_WhenPlayerHasAnsweredAllQuestions_ThenGameIsOver(){
          
          game.answerCurrentQuestion(with: true)
          game.answerCurrentQuestion(with: true)
      
          XCTAssertEqual(game.state, .over)
          
      }
      
    
}
