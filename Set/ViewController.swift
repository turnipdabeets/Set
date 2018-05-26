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
    private lazy var totalCardPlaceholder = cardButtons.count
    private var visibleSet = Set<Int>()
    
    @IBAction func dealThreeMore(_ sender: UIButton) {
        // TODO: make sure no set exisit before dealing more
        if visibleSet.count < totalCardPlaceholder {
            visibleSet = getUniqueRandomNumbers(for: visibleSet, total: visibleSet.count + 3)
            styleVisibleCards()
        }else {
            print("can't deal anymore cards, no room on screen!")
        }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            let card = game.cards[cardIndex]
            // set selected style
            if card.isSelected && card.isVisible {
                sender.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                sender.layer.borderWidth = 3.0
            }else {
                sender.layer.borderWidth = 0.0
            }
            let matched = game.checkForMatch()
            print("matched \(matched)")
            print(game.cards)
            if matched {
                // remove border from all cards and hide
                cardButtons.forEach({$0.layer.borderWidth = 0.0})
                for cardIndex in visibleSet {
                    let card = game.cards[cardIndex]
                    let button = cardButtons[cardIndex]
                    if card.isVisible {
                        // style cards
                        style(a: button, by: card)
                    }else {
                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    }
                    
                }
            }
            
            // TODO: if matched do something on ui, if not do something on ui
        }
    }
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            // start with 12 visible cards
            visibleSet = getUniqueRandomNumbers(for: visibleSet, total: 12)
            //  and styles cards
            styleVisibleCards()
        }
    }
    
    private func styleVisibleCards() {
        print("total visibleset \(visibleSet.count), total cards \(game.cards.count)")
        for cardIndex in visibleSet {
            print("selected cardIndex \(cardIndex)")
            let card = game.cards[cardIndex]
            let button = cardButtons[cardIndex]
            // make visible
            game.makeCardVisible(by: cardIndex)
            // style cards
            style(a: button, by: card)
        }
    }
    
    private func getUniqueRandomNumbers(for set: Set<Int>, total: Int) -> Set<Int> {
        var uniqueNumbers = set
        while uniqueNumbers.count < total {
            let randomInt = Int(arc4random_uniform(UInt32(totalCardPlaceholder)))
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

