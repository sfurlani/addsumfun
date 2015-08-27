//
//  Answers.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import Foundation

protocol AnswerType {
    
    var equation: EquationType { get }
    
    var entered: UInt { get }
    
    func isCorrect() -> Bool
    
}

extension AnswerType {
    
    func isCorrect() -> Bool {
        return equation.testCorrectness(entered)
    }
    
}


struct Answer : AnswerType {
    
    let entered: UInt
    
    let equation: EquationType
    
}
