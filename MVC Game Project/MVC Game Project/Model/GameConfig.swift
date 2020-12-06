//
//  GameConfig.swift
//  MVC Game Project
//
//  Created by user172943 on 8/17/20.
//  Copyright © 2020 Pierre Costin. All rights reserved.
//

import Foundation

struct GameConfig {
    
    
    var PlayerName : String?
    var NumberOfQuestions : Int = 10
    var Levels :String = "any"
    var Categories: Int = 0
    
    enum Status {
        case accepted
        case rejected(String)
    }
    
    var status: Status {
        
    if PlayerName == nil || PlayerName == "" {
        return .rejected("Vous n'avez pas indiqué votre nom !")
    } else {
        return .accepted
        }
    
}
}
