//
//  PlayViewController.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    enum SegueIdentifiers: String {
        case EmbedNumbers = "embedNumbers"
        case EmbedEquation = "embedEquation"
        case ShowVerticalEquation = "showVertical"
        case ShowHorizontalEquation = "showHorizontal"
        case ShowResults = "showResults"
    }
    
    @IBOutlet var equationContainer: UIView!
    @IBOutlet var numberContainer: UIView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet var correctView: UIImageView!
    @IBOutlet var incorrectView: UIImageView!
    
    // MARK: - Properties
    
    var numbersViewController: NumbersViewController!
    var equationViewController: EquationViewController? {
        let filtered = childViewControllers.filter { ($0 as? EquationViewController) != nil ? true : false  }
        return filtered.first as? EquationViewController
    }
    
    var gameData: GameType!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - IBActions
    
    @IBAction func panUpdate(sender: UIPanGestureRecognizer) {
        
        gestureSwitch: switch sender.state {
            
        case .Began:
            numbersViewController.beginDraggingView(sender)
            
        case .Changed:
            numbersViewController.updateDraggingView(sender)
            
        case .Ended:
            
            guard let panView = numbersViewController.panView, let number = panView.number else {
                break gestureSwitch
            }
            let switchValue = equationViewController?.switchNumber(number, gesture: sender)
            numbersViewController.endDraggingView(switchValue ?? false, gesture: sender)
            
        default:
            break gestureSwitch
        }
        
    }

    @IBAction func unwindForNewGame(segue: UIStoryboardSegue) {
        gameData.addNewRound()
        equationViewController?.view.hidden = true
        performSegueWithIdentifier(SegueIdentifiers.ShowVerticalEquation.rawValue, sender: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.destinationViewController {
            
        case let vc as NumbersViewController:
            self.numbersViewController = vc
            
        case let vc as EquationViewController:
            vc.equation = gameData?.currentEquation
            vc.delegate = self
        case let vc as ResultsViewController:
            vc.gameData = gameData
        default:
            break
        }
        
    }
    
    private func answerEquation(entered: UInt) {
        guard let answer = gameData.addNewAnswer(entered) else {
            print("Could not generate answer: \(entered)")
            return
        }
        
        if answer.isCorrect() {
            showSuccess(advanceToNextScreen)
        }
        else {
            showFailure(advanceToNextScreen)
        }
        
    }
    
    private func advanceToNextScreen() {
        if let _ = gameData?.currentEquation {
            let segue = gameData.answers.count % 2 == 0 ? SegueIdentifiers.ShowVerticalEquation.rawValue : SegueIdentifiers.ShowHorizontalEquation.rawValue
            performSegueWithIdentifier(segue, sender: nil)
        }
        else {
            performSegueWithIdentifier(SegueIdentifiers.ShowResults.rawValue, sender: nil)
        }
    }
    
    // MARK: Navigation Animations
    
    typealias Callback = () -> ()
    
    private func showSuccess(callback: Callback? ) {
        showResult(correctView, callback: callback)
    }
    
    private func showFailure(callback: Callback? ) {
        showResult(incorrectView, callback: callback)
    }
    
    private func showResult(imageView: UIImageView, callback: Callback?) {
        let diameter = min(view.frame.width, view.frame.height) * 0.8
        let radius = diameter / 2
        view.addSubview(imageView)
        imageView.alpha = 0.0
        imageView.frame = CGRect(x: view.frame.midX - radius, y: view.frame.midY - radius, width: diameter, height: diameter)
        imageView.tintColor = UIColor.whiteColor()
        imageView.layer.cornerRadius = radius
        imageView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        UIView.animateWithDuration( 0.3,
            delay: 0.1,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.CurveEaseOut],
            animations: {
                imageView.alpha = 1.0
                imageView.transform = CGAffineTransformIdentity
            },
            completion: { (_) in
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(200 * NSEC_PER_MSEC)), dispatch_get_main_queue()) {
                    self.hideResult(imageView, callback: callback)
                }
            }
        )
    }
    
    private func hideResult(imageView: UIImageView, callback: Callback?) {
        UIView.animateWithDuration( 0.2,
            animations: {
                imageView.alpha = 0.0
            },
            completion: { (_) in
                imageView.removeFromSuperview()
                callback?()
            }
        )
    }
    
}

extension PlayViewController: EquationViewControllerDelegate {

    func didEnterResult(result: UInt) {
        print("Recieved: \(result)")
        answerEquation(UInt(result))
    }
    
}
