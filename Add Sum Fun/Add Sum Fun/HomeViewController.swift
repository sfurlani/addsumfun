//
//  HomeViewController.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    enum SegueIdentifiers: String {
        case BeginGame = "beginGame"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.destinationViewController {
        case let vc as PlayViewController:
            vc.gameData = GameData()
        default:
            break
        }
    }
    
    @IBAction func unwindForMainMenu(segue: UIStoryboardSegue) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

}
