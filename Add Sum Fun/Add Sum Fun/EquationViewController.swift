//
//  EquationViewController.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

protocol EquationViewControllerDelegate {
    
    func didEnterResult(result: UInt)
}

class EquationViewController: UIViewController {

    @IBOutlet var augendRow: UIStackView!
    
    @IBOutlet var addendRow: UIStackView!
    
    @IBOutlet var sumRow: UIStackView!
    
    var entryViews: [NumberView] = [] 
    
    var equation: EquationType!
    
    var delegate: EquationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateDisplay(equation)
    }
    
    private func updateDisplay(equation: EquationType) {
        
        guard let augendRow = augendRow, let addendRow = addendRow, let sumRow = sumRow else {
            return
        }
        
        let augViews = equation.lhs.toDigits(5).map { NumberView.newWithNumber($0) }
        
        for case let numberView? in augViews {
            augendRow.addArrangedSubview(numberView)
            if numberView.number == nil {
                numberView.hidden = true
            }
        }
        
        let addViews = equation.rhs.toDigits(5).map { NumberView.newWithNumber($0) }
        
        for case let numberView? in addViews {
            addendRow.addArrangedSubview(numberView)
            if numberView.number == nil {
                numberView.hidden = true
            }
        }
        
        let sum = Int(equation.result)
        
        entryViews = sum.toDigits().map { (_: Int?) -> NumberView in
            return NumberView.newWithNumber(nil)!
        }
        
        for case let numberView in entryViews {
            sumRow.addArrangedSubview(numberView)
        }
    }
    
    func switchNumber(number: UInt, gesture: UIPanGestureRecognizer) -> Bool {
        let location = gesture.locationInView(view)
        guard let numberView = view.hitTest(location, withEvent: nil) as? NumberView else {
            return false
        }
        
        guard let index = entryViews.indexOf(numberView) else {
            return false
        }
        
        numberView.hidden = true
        
        
        let newView = NumberView.newWithNumber(number)!
        newView.frame = numberView.frame
        newView.alpha = 0.0
        
        sumRow.removeArrangedSubview(numberView)
        entryViews.removeAtIndex(index)
        entryViews.insert(newView, atIndex: index)
        sumRow.insertArrangedSubview(newView, atIndex: index)
        
        self.sumRow.layoutIfNeeded()
        
        UIView.animateWithDuration(0.2, animations: { newView.alpha = 1.0 }, completion: { (_) in
            if let result = self.checkResult() {
                self.delegate?.didEnterResult(result)
            }
        })
        
        
        return true
    }
    
    func checkResult() -> UInt? {
        let result = calculateResponse(entryViews.map { $0.number })
        print(result)
        
        let total = entryViews.reduce(0) {  $0 + ($1.number != nil ? 1 : 0) }
        guard Int(total) == entryViews.count else {
            return nil
        }
        
        return result
    }

    
    private func calculateResponse(entered: [UInt?]) -> UInt {
        var tens: UInt = 0
        var sum: UInt = 0
        for place in entered.reverse() {
            if let place = place {
                sum += place * pow(10, exponent: tens)
            }
            tens++
        }
        return sum
    }
    
    private func pow(base: UInt, exponent: UInt) -> UInt {
        guard exponent > 0 else {
            return 1
        }
        
        return pow(base, exponent: exponent - 1) * 10
    }
    
}
