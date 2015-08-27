//
//  ResultsViewController.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/27/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {
    @IBOutlet weak var mainMenu: UIButton!
    @IBOutlet weak var newGame: UIButton!

    enum ReuseIdentifiers: String {
        case AnswerCell = "answerCell"
    }
    
    var gameData: GameType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameData?.answers.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifiers.AnswerCell.rawValue, forIndexPath: indexPath)

        // Configure the cell...
        
        let answer = gameData.answers[indexPath.row]
        
        cell.textLabel?.text = "\(answer.equation.lhs) + \(answer.equation.rhs) = \(answer.equation.result)"
        cell.detailTextLabel?.text = "\(answer.entered)"
        cell.detailTextLabel?.textColor = answer.isCorrect() ? UIColor.greenColor() : UIColor.redColor()
        
        cell.imageView?.image = UIImage(named: answer.isCorrect() ? "correct" : "incorrect" )
        cell.imageView?.tintColor = answer.isCorrect() ? UIColor.greenColor() : UIColor.redColor()

        return cell
    }

    @IBAction func returnToMainMenu(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func startNewGame(sender: AnyObject) {
        gameData.addNewRound()
    }

}
