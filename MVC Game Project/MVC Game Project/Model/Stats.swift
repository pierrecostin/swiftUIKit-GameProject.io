//
//  GameStats.swift
//  MVC Game Project
//
//  Created by PD Berlin01 on 10.08.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import Foundation

struct Stats {

	var numberOfGames = 0
	var scores: [Int] = []

	var minScore = 0
	var maxScore = 0

	var maxScorelastGame = 0
	var MinScoreLastgame = 0

	func getMinScore() -> Int {
		scores.min() ?? 0
	}

	func getMaxScore() -> Int {
		scores.max() ?? 0
	}

}
