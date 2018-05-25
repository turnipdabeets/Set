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
    }
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            
            let colorGroup = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)]
            let symbolGroup = ["\u{25B2}", "\u{25AE}", "\u{25CF}"] // triangle, rectangle, circle
            
            for button in cardButtons {
                if let cardIndex = cardButtons.index(of: button){
                    let card = game.cards[cardIndex]
                    let cardColor = colorGroup[card.color]
                    var attribute: [NSAttributedStringKey: Any] = [:]
                        if card.shading == 0 {
                            // striped
                            attribute[.foregroundColor] = cardColor.withAlphaComponent(0.15)
                        } else if card.shading == 1 {
                            // solid
                            attribute[.foregroundColor] = cardColor.withAlphaComponent(1.0)
                        } else {
                            // open
                            attribute[.strokeColor] = cardColor
                            attribute[.strokeWidth] = 5.0
                        }
                    var shape = ""
                    for _ in 0...card.number {
                        shape += symbolGroup[card.symbol]
                    }
                    let attributedString = NSAttributedString(string: shape, attributes: attribute)
                    button.setAttributedTitle(attributedString, for: .normal)
                }
            }
        }
    }
    
    
}

