//
//  ViewController.swift
//  MVC Game Project
//
//  Created by PD Berlin01 on 18.06.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//
import Foundation
import UIKit

protocol GameDelegate: class {
	var game: Game! { get set }
}

enum ScoreStatus {
	case improved
	case worsened
}

class GameViewController: UIViewController {
    
    static var config = GameConfig()
    
	var isCorrect = false
	weak var delegate: GameDelegate?

	static let notificationName = "questionsLoaded"

	let readyNotification = Notification.Name(rawValue: notificationName)

	var game = Game(withNotificationName: notificationName)

	var currentMinScore = 0
	var currentMaxScore = 0

	var halfOfQuestions: Int {
		game.questions.count / 2
	}

	@IBAction func closeButton(_ sender: Any) {
		dismiss(animated: true) {
			self.delegate?.game = self.game
		}
	}
	@IBOutlet weak var newGameButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var scoreLabel: UILabel!

	@IBOutlet weak var questionView: QuestionView!

	@IBOutlet weak var sliderOutlet: UISlider!
	@IBOutlet weak var sliderButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: readyNotification, object: nil)

		startNewGame()

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
		questionView.addGestureRecognizer(panGestureRecognizer)

		sliderOutlet.isHidden = true

		currentMinScore = game.myStats.getMinScore()
		currentMaxScore = game.myStats.getMaxScore()

	}

	@objc func questionsLoaded() {
		activityIndicator.isHidden = true
		newGameButton.isHidden = false
		questionView.title = game.currentQuestion.title
	}

	@IBAction func showSlider(_ sender: Any) {

		sliderOutlet.isHidden = !sliderOutlet.isHidden

		if sliderOutlet.isHidden {
			sliderButton.setTitle("Show Slider", for: .normal)

		} else {
			sliderButton.setTitle("Hide Slider", for: .normal)

		}

	}

	@IBAction func sliderAction(_ sender: UISlider) {
		print(sender.value)
		let newValue = Int(sender.value)
		sender.setValue(Float(newValue), animated: false)
		print(newValue)
		questionView.fontSize = newValue
	}

	@IBAction func didTapNewGameButton() {
		startNewGame()

	}

	private func updateScoresStats() {
		currentMinScore = game.myStats.getMinScore()
		currentMaxScore = game.myStats.getMaxScore()

		print("This is the min score")
		print(currentMinScore)

		print("This is the max score")
		print(currentMaxScore)

	}

	private func startNewGame() {

		updateScoresStats()

		activityIndicator.isHidden = false
		newGameButton.isHidden = true

		questionView.title = "Loading. . ."
		questionView.style = .standard
		scoreLabel.text = "0/10"

		game.refresh()

		print ("game stats \(game.myStats.numberOfGames)")

	}

	@objc func dragQuestionView(_ sender: UIPanGestureRecognizer){
		if game.state == .ongoing {
			switch sender.state {
				case .began, .changed:
					transformQuestionViewWith(gesture: sender)
				case .cancelled, .ended:
					answerQuestion()
				default:
					break
			}
		}
	}

	private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: questionView)
		let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)

		let screenWidth = UIScreen.main.bounds.width
		let translationPercent = translation.x
			/ (screenWidth/2)
		let rotationAngle = (CGFloat.pi / 6) * translationPercent

		let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)

		let transform = translationTransform.concatenating(rotationTransform)
		questionView.transform = transform

		if translation.x > 0 {
			questionView.style = .correct
		} else {
			questionView.style = .incorrect
		}
	}

	private func answerQuestion() {
		switch questionView.style {
			case .correct:
				game.answerCurrentQuestion(with: true)
			case .incorrect:
				game.answerCurrentQuestion(with: false)
			default:
				break
		}

		scoreLabel.text = "\(game.score)/10"
		scoreLabel.rotate(duration: 1.0)

		if game.currentQuestion == game.questions[halfOfQuestions]{
			if game.myStats.numberOfGames > 0{
				presentStatsAlert(stats: game.myStats)
			}

		}

		questionView.transform = .identity
		questionView.style = .standard
		questionView.title = game.currentQuestion.title

		let screenWidth = UIScreen.main.bounds.width
		var translationTransform : CGAffineTransform
		if questionView.style == .correct { translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
		} else {
			translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
		}
		UIView.animate(withDuration: 0.3, animations: {
			self.questionView.transform = translationTransform
		}) { (success) in
			if success {
				self.showQuestionView()
			}
		}
	}

	private func showQuestionView() {
		questionView.transform = .identity
		questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
		questionView.style = .standard

		switch game.state {
			case .ongoing:
				questionView.title = game.currentQuestion.title
			case .over:

				if game.myStats.numberOfGames > 1 {
					presentScoreOutcomeAlert(stats: game.myStats)
				}
				questionView.title = "Game Over"
		}

		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {self.questionView.transform = .identity}, completion: nil)

	}

	func presentStatsAlert(stats: Stats) {

		var alert : UIAlertController!

		let currentScore = game.score
		let currentMinScore = stats.getMinScore()
		let currentMaxScore = stats.getMaxScore()
		let expectedImprovedScore = currentMaxScore - currentScore + 1
		let expectedWorsenScore = currentMinScore - currentScore 

		let canImproveMessage = "You can improve your score if you answer \(expectedImprovedScore) question(s) correctly"

		let canWorsenMessage = "You can worsen your low score if you don't answer at least \(expectedWorsenScore) question(s) correctly"


		if currentScore < currentMinScore {

			alert = UIAlertController(title: "Your Score Alert!", message: canWorsenMessage, preferredStyle: .alert)


		} else {

			alert = UIAlertController(title: "Your Score Alert!", message: canImproveMessage, preferredStyle: .alert)

		}


		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "segueToStart" {

			guard let startVC = segue.destination as? StartViewController else {
				return
			}

			startVC.game = game //we send the data via the properties

		}
	}



	func presentScoreOutcomeAlert(stats: Stats) {

		let finalScore = game.score

		let improvedMessage = "You have improved your High Score, you are a genius!\n\nYour previous High Score was \(currentMaxScore). Your new High Score is \(finalScore)"

		let worsenedMessage = "You have worsened your Low Score.\n\nYou are a Moron!\n\nYour previous Low Score was \(currentMinScore). Your embarassing new Low Score is \(finalScore).\n\nSAD!"

		let sameHighScoreMessage = "Your high score is holding steady"

		//		let sameLowScoreMessage = "Your Low score is holding steady"

		let keepTryingMessage = "Why haven't you been able to improve your high score??. Keep trying!"

		var alert: UIAlertController!

		print(finalScore)
		print("The Max Score: \(currentMaxScore)")
		print("The Min Score:  \(currentMinScore)")

		if finalScore == currentMaxScore {

			alert = UIAlertController(title: "Your Score Status!", message: sameHighScoreMessage, preferredStyle: .alert)

		} else if finalScore > currentMaxScore {

			alert = UIAlertController(title: "Your Score Status!", message: improvedMessage, preferredStyle: .alert)

		} else if finalScore < currentMinScore {

			alert = UIAlertController(title: "Your Score Alert!", message: worsenedMessage, preferredStyle: .alert)

		} else {

			alert = UIAlertController(title: "Your Score Alert!", message: keepTryingMessage, preferredStyle: .alert)

		}

		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

		present(alert, animated: true, completion: nil)

	}

}



extension UIView {

	private static let rotationAnimationKey = "rotationanimationkey"

	func rotate(duration: Double = 1.0) {

		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
		rotationAnimation.fromValue = 0.0
		rotationAnimation.toValue = Float.pi * 2
		rotationAnimation.duration = duration

		layer.add(rotationAnimation, forKey: UIView.rotationAnimationKey)

	}

}


