//
//  StartViewController.swift
//  MVC Game Project
//
//  Created by PD Berlin01 on 10.08.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, GameDelegate {

	var game: Game!
    var Config :GameConfig!
	override func viewDidLoad() {
		super.viewDidLoad()

		if let game = game {
			print("StartViewController: game stats \(game.myStats.numberOfGames)")
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "gameSegue" {
			let gameVC = segue.destination as! GameViewController
			if let game = game {
				gameVC.game = game
			}
			gameVC.delegate = self
		}
		if let game = game, segue.identifier == "segueToStats" {
			let statsVC = segue.destination as! GameStatsViewController
			statsVC.stats = game.myStats
		}
	}


}
