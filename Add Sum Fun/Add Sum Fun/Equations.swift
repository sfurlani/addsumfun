//
//  Equations.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import Foundation

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

/// Returns a random number within the specified range.  Default is entire UInt range.
func randomNumber(range: Range<UInt> = UInt.min...UInt.max) -> UInt {
    let min = range.startIndex
    let max = range.endIndex
    return UInt(arc4random_uniform(UInt32(max - min))) + min
}
