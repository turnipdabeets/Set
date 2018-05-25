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
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            
            var colorGroup = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)]
            
            for button in cardButtons {
                if let cardIndex = cardButtons.index(of: button){
//                    print("button \(button) \(cardIndex)")
//                    print("matching card \(game.cards[cardIndex])")
                    let card = game.cards[cardIndex]
                    print(card.color)
                    let attribute: [NSAttributedStringKey: Any] = [
                        .strokeColor: colorGroup[card.color],
                        .strokeWidth: 5.0
                    ]
                    let attributedString = NSAttributedString(string: "hello", attributes: attribute)
                    button.setAttributedTitle(attributedString, for: .normal)
//                    var a = button.attributedTitle(for: UIControlState.normal)
//                    print("hm", a)

                }
                
            }
//            print("cards set \(self) \(cardButtons)")
        }
    }
    
    
    

}

