//: Playground - noun: a place where people can play

import UIKit



protocol EquationType {
    
    var lhs: UInt { get }
    var rhs: UInt { get }
    var function: (UInt, UInt) -> UInt { get }
    func testCorrectness(result: UInt) -> Bool
}

extension EquationType {
    
    var result: UInt {
        get {
            return function(lhs, rhs)
        }
    }
    
    func testCorrectness(result: UInt) -> Bool {
        return result == self.result
    }
}


protocol AnswerType {
    
    var equation: EquationType { get }
    
    var entered: UInt { get }
    
    func isCorrect() -> Bool
    
}

protocol GameType {
    
    var equations: [EquationType] { get }
    var answers: [AnswerType] { get }
    func score() -> CGFloat?
    mutating func addNewRound() -> ()
}

extension GameType {
    
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

/// Helper Method
func randomNumber(range: Range<UInt> = UInt.min...UInt.max) -> UInt {
    let min = range.startIndex
    let max = range.endIndex
    return UInt(arc4random_uniform(UInt32(max - min))) + min
}

struct Addition : EquationType {
    
    let lhs: UInt
    
    let rhs: UInt
    
    var function: (UInt,  UInt) -> UInt {
        get {
            return { $0 + $1 }
        }
    }
    
    init(range: Range<UInt> = 10...99_999) {
        
        lhs = randomNumber(range)
        rhs = randomNumber(range)
    }
}

struct Answer : AnswerType {
    
    let entered: UInt
    
    let equation: EquationType
    
    func isCorrect() -> Bool {
        return equation.testCorrectness(entered)
    }
}

extension UInt {
    func apply<T>(transform: (UInt) -> T) -> [T] {
        var result = [T]()
        for index in 0..<self {
            result.append(transform(index))
        }
        return result
    }
}

class GameData : GameType {

    private(set) var equations: [EquationType]
    private(set) var answers: [AnswerType]
    let roundSize: UInt
    
    init(roundSize: UInt = 5) {
        self.roundSize = roundSize
        
        equations = self.roundSize.apply { (index: UInt) in
            return Addition()
        }
        answers = [AnswerType]()
    }
    
    func addNewRound() -> () {
        equations = equations + self.roundSize.apply { (index: UInt) in
            return Addition()
        }
    }
}


let game = GameData()

let first = game.equations[1]
var string = ""
for eq in game.equations {
    string += "EQ: \(eq.lhs) + \(eq.rhs) = \(eq.result)\n"
}
print(string)

game.addNewRound()
string = ""
for eq in game.equations {
    string += "EQ: \(eq.lhs) + \(eq.rhs) = \(eq.result)\n"
}
print(string)

let noScore = game.score()

private func pow(base: Int, exponent: Int) -> Int {
    guard exponent > 0 else {
        return 1
    }
    
    return pow(base, exponent: exponent - 1) * 10
}

let hun = pow(10, exponent: 2)

let mil = pow(10, exponent: 6)

private func calculateResponse(entered: [Int?]) -> Int {
    var tens = 0
    var sum = 0
    for place in entered.reverse() {
        if let place = place {
            sum += place * pow(10, exponent: tens)
        }
        tens++
    }
    return sum
}

calculateResponse([0,0])

calculateResponse([1,1,4])


