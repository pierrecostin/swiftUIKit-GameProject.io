//
//  QuestionView.swift
//  MVC Game Project
//
//  Created by PD Berlin01 on 26.06.20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(style)
            }
        
}
    private func setStyle(_ style: Style){
        switch style {
        case .correct:
            backgroundColor = #colorLiteral(red: 0.785051167, green: 0.9263257384, blue: 0.6261575222, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9528643489, green: 0.5298117995, blue: 0.5795843601, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7483419776, green: 0.7683829665, blue: 0.7891533971, alpha: 1)
            icon.isHidden = true
        }
        
    }
    
    var title = ""{
        didSet {
            label.text = title
        }
    }
    
    var fontSize = 0{
        didSet {
            label.text = title
            label.font = UIFont(name: label.font.fontName, size: CGFloat(fontSize))!
        }
    }
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
}
