//
//  GameStatsViewController.swift
//  MVC Game Project
//
//  Created by PD Berlin01 on 10.08.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import UIKit

class GameStatsViewController: UIViewController {
    
    @IBOutlet weak var minScoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    @IBOutlet weak var gameStatLabel: UILabel!
    
    var stats: Stats!
    
    var minScore: Int = 0
    var maxScore: Int = 0
    var numberOfQuestions: Int = 10
    var minScorePercentage: Float = 0
    var maxScorePercentage: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextLabel()
        setMinScoreLabel()
        setMaxScoreLabel()
    }
    
    private func setMinScoreLabel() {
        let scores = stats.scores
        guard let minScore = scores.min(by: { $0 < $1 }) else {
            return
        }
        self.minScore = minScore
        minScoreLabel.text = "Min Score: \(minScore),  \(calculateMinScorePercentage(numberOfQuestions, minScore))%"
    }
    
    private func setMaxScoreLabel() {
        let scores = stats.scores
        guard let maxScore = scores.max(by: { $0 < $1 }) else {
            return
        }
        self.maxScore = maxScore
        maxScoreLabel.text = "Max Score: \(maxScore), \(calculateMaxScorePercentage(numberOfQuestions, maxScore))%"
    }
    
    private func setTextLabel() {
        if let stats = stats {
            gameStatLabel.text = """
            \(stats.numberOfGames) Games
            """
        }
        
    }
    
}

extension GameStatsViewController {
    
    func calculateMinScorePercentage(_ numberOfQuestions: Int, _ minScore: Int) -> Float {
        return Float(minScore) / Float(numberOfQuestions) * 100
    }
    
    func calculateMaxScorePercentage(_ numberOfQuestions: Int, _ maxScore: Int) -> Float {
        return Float(maxScore) / Float(numberOfQuestions) * 100
    }
    
}
