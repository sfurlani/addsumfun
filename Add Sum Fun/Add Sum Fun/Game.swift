//
//  Game.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import Foundation
import CoreGraphics

protocol GameType {
    
    var equations: [EquationType] { get }
    var answers: [AnswerType] { get }
    var currentEquation: EquationType? { get }
    func score() -> CGFloat?
    mutating func addNewRound() -> ()
    mutating func addNewAnswer(answer: UInt) -> ()
    
}

extension GameType {
    
    var currentEquation: EquationType? {
        guard equations.count > answers.count else {
            return nil
        }
        return equations[answers.count]
    }
    
    func score() -> CGFloat? {
        
        guard equations.count == answers.count else {
            return nil
        }
        
        let correct = answers.reduce(0) { (count: UInt, answer: AnswerType) -> UInt in
            return count + (answer.isCorrect() ? 1 : 0)
        }
        
        return CGFloat(correct) / CGFloat(equations.count)
    }
}

class GameData : GameType {
    
    private(set) var equations: [EquationType]
    private(set) var answers: [AnswerType]
    let roundSize: UInt
    
    init(roundSize: UInt = 5) {
        self.roundSize = roundSize
        
        equations = self.roundSize.repeatMap { (index: UInt) in
            return Addition()
        }
        answers = [AnswerType]()
    }
    
    func addNewRound() -> () {
        equations = equations + self.roundSize.repeatMap { (index: UInt) in
            return Addition()
        }
    }
    
    func addNewAnswer(answer: UInt) {
        if let equation = currentEquation {
            answers.append(Answer(entered:answer, equation: equation))
        }
        else {
            
        }
    }
}
