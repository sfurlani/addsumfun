//
//  EquationViewController.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class EquationViewController: UIViewController {

    @IBOutlet var augendRow: UIStackView!
    
    @IBOutlet var addendRow: UIStackView!
    
    @IBOutlet var sumRow: UIStackView!
    
    var entryViews: [NumberView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let aug = 20
        let add = 234
        let sum = aug + add
        
        let augViews = aug.toDigits(5).map { NumberView.newWithNumber($0) }
        
        for case let numberView? in augViews {
            augendRow.addArrangedSubview(numberView)
            if numberView.number == nil {
                numberView.hidden = true
            }
        }
        
        let addViews = add.toDigits(5).map { NumberView.newWithNumber($0) }
        
        for case let numberView? in addViews {
            addendRow.addArrangedSubview(numberView)
            if numberView.number == nil {
                numberView.hidden = true
            }
        }
        
        entryViews = sum.toDigits().map { (_: Int?) -> NumberView in
            return NumberView.newWithNumber(nil)!
        }
        
        for case let numberView in entryViews {
            sumRow.addArrangedSubview(numberView)
        }
        
        
    }
    
    func switchNumber(number: Int, gesture: UIPanGestureRecognizer) -> Bool {
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
        
        UIView.animateWithDuration(0.1) { () -> Void in
            newView.alpha = 1.0
        }
        
        
        return true
    }
    

}
