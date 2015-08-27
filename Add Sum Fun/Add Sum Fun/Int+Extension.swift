//
//  Int+Extension.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import Foundation


/// calls transform "self" number of times and returns the array
extension UInt {
    func repeatMap<T>(transform: (UInt) -> T) -> [T] {
        var result = [T]()
        for index in 0..<self {
            result.append(transform(index))
        }
        return result
    }
}

/// calls transform "self" number of times and returns the array
extension Int {
    func repeatMap<T>(transform: (Int) -> T) -> [T] {
        var result = [T]()
        for index in 0..<self {
            result.append(transform(index))
        }
        return result
    }
}


private func maximum(x: Int, _ y: Int) -> Int {
    return max(x, y)
}

extension UInt {
    func toDigits(places: Int = 0) -> [UInt?]
    {
        
        let characters = String(self).characters
        
        var digits = characters.map { UInt(String($0)) }
        
        if digits.count < places {
            let buffer = [UInt?](count: places - digits.count, repeatedValue: nil)
            digits.insertContentsOf(buffer, at: 0)
        }
        
        return digits
        
    }
}

extension Int {
    func toDigits(places: Int = 0) -> [Int?]
    {
        
        let characters = String(self).characters
        
        var digits = characters.map { Int(String($0)) }
        
        if digits.count < places {
            let buffer = [Int?](count: places - digits.count, repeatedValue: nil)
            digits.insertContentsOf(buffer, at: 0)
        }
        
        return digits
        
    }
}
