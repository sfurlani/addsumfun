//
//  ContainerTransitionSegue.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class ContainerTransitionSegue: UIStoryboardSegue {

    override func perform() {
        
        guard let parent = sourceViewController as? PlayViewController else {
            print("Using Wrong Parent Controller: \(sourceViewController)")
            return
        }
        guard let source = parent.equationViewController else {
            print("Doesn't have source \(parent.childViewControllers)")
            return
        }
        let destination = destinationViewController
        
        print(parent)
        print(source)
        print(destination)
        
        let inFinal = parent.equationContainer.bounds
        let offRight = CGRectOffset(inFinal, inFinal.width, 0)
        let offLeft = CGRectOffset(inFinal, -inFinal.width, 0)
        
        parent.addChildViewController(destination)
        destination.view.frame = offRight
        parent.view.layoutIfNeeded()
        
        source.willMoveToParentViewController(nil)
        
        parent.transitionFromViewController(source,
            toViewController: destination,
            duration: 0.5,
            options: [ .CurveEaseOut],
            animations: {
                source.view.frame = offLeft
                destination.view.frame = inFinal
            },
            completion: { (_) in
                source.removeFromParentViewController()
            }
        )
        
    }
    
}
