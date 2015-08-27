//
//  NumbersViewController.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class NumbersViewController: UIViewController {

    @IBOutlet var numberRow: UIStackView!
    
    private(set) var panStart: CGPoint?
    private(set) var panView: NumberView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let numberViews = (0...9).map { (index: UInt) in NumberView.newWithNumber(index) }
        
        for case let numberView? in numberViews {
            
            numberView.userInteractionEnabled = true
            numberRow.addArrangedSubview(numberView)
        }
        numberRow.setNeedsLayout()
    }

    private func numberViewForGesture(gesture: UIPanGestureRecognizer) -> NumberView? {
        let location = gesture.locationInView(view)
        return view.hitTest(location, withEvent: nil) as? NumberView
    }
    
    // MARK: - Gesture Actions
    
    func beginDraggingView(gesture: UIPanGestureRecognizer) -> Bool{

        guard let numberView = numberViewForGesture(gesture) else {
            panStart = nil
            panView = nil
            return false
        }
        
        panStart = gesture.locationInView(view)
        panView = numberView
        return true
    }
    
    func updateDraggingView(gesture: UIPanGestureRecognizer) {
        
        guard let panView = panView, panStart = panStart else {
            return
        }
        
        let location = gesture.locationInView(view)
        
        panView.transform = transform(panStart, to: location)
    }
    
    func endDraggingView(switchViews: Bool, gesture: UIPanGestureRecognizer) {
        guard let panView = panView else {
            return
        }
        
        if switchViews {
            UIView.animateWithDuration(0.1, delay: 0, options: [], animations: { () -> Void in
                panView.alpha = 0.0
                }, completion: { (finished: Bool) -> Void in
                    panView.transform = CGAffineTransformIdentity
                    
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        
                        panView.alpha = 1.0
                    })
            })
        }
        else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                panView.transform = CGAffineTransformIdentity
            })
        }
        
        self.panView = nil
        self.panStart = nil
    }
    
    private func transform(start: CGPoint, to: CGPoint) -> CGAffineTransform {
        let dX = to.x - start.x
        let dY = to.y - start.y
        return CGAffineTransformMakeTranslation(dX, dY)
    }
}
