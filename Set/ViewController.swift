//
//  ViewController.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = SetGame()
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            let card = game.cards[cardIndex]
            // set selected style
            if card.isSelected && card.isVisible {
                sender.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                sender.layer.borderWidth = 3.0
            }else {
                sender.layer.borderWidth = 0.0
            }
        }
    }
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            // start with 12 visible and styles cards
            let startingSet = getRandomNumbers(of: cardButtons.count, unique: 12)
            for cardIndex in startingSet {
               let card = game.cards[cardIndex]
               let button = cardButtons[cardIndex]
                // make visible
                game.makeCardVisible(by: cardIndex)
                // style cards
                style(a: button, by: card)
            }
        }
    }
    
    private func getRandomNumbers(of index: Int, unique total: Int) -> Set<Int> {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < total {
            let randomInt = Int(arc4random_uniform(UInt32(24)))
            uniqueNumbers.insert(randomInt)
        }
        return uniqueNumbers
    }

    
    private func style(a button: UIButton, by card: Card) {
        // with color
        let colorGroup = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)]
        let cardColor = colorGroup[card.color]
        // with symbol
        let symbolGroup = ["\u{25B2}", "\u{25AE}", "\u{25CF}"] // triangle, rectangle, circle
        // with shading
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
        // with number
        var shape = ""
        for _ in 0...card.number {
            shape += symbolGroup[card.symbol]
        }
        // set attributes
        let attributedString = NSAttributedString(string: shape, attributes: attribute)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
    
}

