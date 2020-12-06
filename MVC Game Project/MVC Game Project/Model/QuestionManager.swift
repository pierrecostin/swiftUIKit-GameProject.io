//
//  QuestionManager.swift
//  MVC Game Project
//
//  Created by PD Berlin01 on 26.06.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import Foundation
import UIKit
class QuestionManager {
    let url = URL(string: "https://opentdb.com/api.php?amount=10&type=boolean")!

    static let shared = QuestionManager()
    
   // private init() {}
    
    func get(completionHandler: @escaping ([Question]) -> ()) {
        let task = URLSession.shared.dataTask(with: self.url) { (data, response, error) in
            guard error == nil else {
                completionHandler([Question]())
                return
            }
            DispatchQueue.main.async {
                completionHandler(self.parse(data: data))
            }
        }
        task.resume()
    }

    func parse(data: Data?) -> [Question] {
        guard let data = data,
            let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []),
            let parsedJson = serializedJson as? [String: Any],
            let results = parsedJson["results"] as? [[String: Any]] else {
                return [Question]()
        }
        return getQuestionsFrom(parsedDatas: results)
    }

    func getQuestionsFrom(parsedDatas: [[String: Any]]) -> [Question]{
        var retrievedQuestions = [Question]()

        for parsedData in parsedDatas {
            retrievedQuestions.append(getQuestionFrom(parsedData: parsedData))
        }

        return retrievedQuestions
    }

    func getQuestionFrom(parsedData: [String: Any]) -> Question {
        if let title = parsedData["question"] as? String,
            let answer = parsedData["correct_answer"] as? String {
            return Question(title: String(htmlEncodedString: title)!, isCorrect: (answer == "True"))
        }
        return Question()
    }
}


extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }
    
}

/*class QuestionManager {

  var numberOfQuestions: Int

  let url = URL(string: "http://whatever.com/amount=\(numberOfQuestions)")

  init(numberOfQuestions: Int) {
    self.numberOfQuestions = numberOfQuestions
  }
}

func refresh() {

  let manager = QuestionManager(numberOfQuestions: 25)

  manager.get { questions in

  }
}*/
