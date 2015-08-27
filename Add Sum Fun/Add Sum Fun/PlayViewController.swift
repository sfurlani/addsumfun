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
    
    var numbersViewController: NumbersViewController!
    var equationViewController: EquationViewController? {
        let filtered = childViewControllers.filter { ($0 as? EquationViewController) != nil ? true : false  }
        return filtered.first as? EquationViewController
    }
    
    var gameData: GameType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        performSegueWithIdentifier(SegueIdentifiers.ShowVerticalEquation.rawValue, sender: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func answerEquation(answer: UInt) {
        gameData.addNewAnswer(answer)
        if let _ = gameData?.currentEquation {
            performSegueWithIdentifier(SegueIdentifiers.ShowVerticalEquation.rawValue, sender: nil)
        }
        else {
            // TODO: Go to Results Screen
            performSegueWithIdentifier(SegueIdentifiers.ShowResults.rawValue, sender: nil)
        }
    }
    
}

extension PlayViewController: EquationViewControllerDelegate {

    func didEnterResult(result: UInt) {
        print("Recieved: \(result)")
        answerEquation(UInt(result))
    }
    
}
