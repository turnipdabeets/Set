//
//  ViewController.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = Set()
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
        }
        print("card selected, \(sender)")
    }
    @IBOutlet var cardButtons: [UIButton]!
    
    
    

}

