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
    var visibleButtons = Set<Int>()
    lazy var totalCardPlaceholder = cardButtons.count
    var hasMatch = false
    
    
    @IBAction func dealThreeMore(_ sender: UIButton) {
        // TODO: add three more cards automatically
        if hasMatch {
            resetCardsStyle()
            game.getNewCards()
            game.resetSelection()
            print("new card order")
            print(game.cards)
            print("________")
            styleVisibleCards()
            hasMatch = false
//            print("reset")
        }else {
            print("just add three more")
            //TODO: make sure no set exisit before dealing more
            if visibleButtons.count < totalCardPlaceholder {
                visibleButtons = getUniqueRandomNumbers(for: visibleButtons, total: visibleButtons.count + 3)
                styleVisibleCards()
            }else {
                print("can't deal anymore cards, no room on screen!")
            }
        }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            
            // clear old cards before selecting new one
            if game.selectedCards.count == 3 && !hasMatch {
                resetCardsStyle()
                game.resetSelection()
            }
            
            // only take action if card pressed is "visible" and do no have a match
            if visibleButtons.contains(index) && !hasMatch{
                // handle selection or deselection logic
                game.touchCard(at: index)
                // handle selection or deselection style
                styleTouched(button: sender, by: game.cards[index])
                // TODO: evalutate if match
                if game.selectedCards.count == 3 {
                    let hasSet = game.evaluateSet()
                    if hasSet {
                        hasMatch = true
                        game.saveMatch()
                    } else {
                        hasMatch = false
                        game.selectedCards.forEach({(card) in
                            if let index = game.cards.index(of: card){
                                cardButtons[index].layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                            }
                        })
                    }
                }
//                let match = game.checkMatch()
                // TODO: if correct do something on ui, if not do something on ui
                // TODO: handle less cards than visible buttons
                //TODO: only allow pressing after hanlding match
                // TODO: remove styles from matched after handling
            }
        }
    }
    
    func resetCardsStyle(){
        for card in game.selectedCards {
            if let index = game.cards.index(of: card){
                let button = cardButtons[index]
                let resetCard = game.unselectCard(by: index)
                styleTouched(button: button, by: resetCard)
            }
        }
    }
    
    func styleTouched(button: UIButton, by card: Card) {
        if card.isSelected {
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            button.layer.borderWidth = 6.0
        }else {
            button.layer.borderWidth = 0.0
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            // initalize with 12 visible buttons
            visibleButtons = getUniqueRandomNumbers(for: visibleButtons, total: 12)
            //  and styles cards
            print("initalize buttson", visibleButtons)
            print("initalize cards")
            print(game.cards)
            print("____________")
            styleVisibleCards()
        }
    }
    
    private func styleVisibleCards() {
        for cardIndex in visibleButtons {
            let card = game.cards[cardIndex]
            let button = cardButtons[cardIndex]
            if !game.matchedCards.contains(card){
                // style cards
                style(a: button, by: card)
            }else {
                // hide
                print("IN MACTHED:")
                print(game.matchedCards)
                print("________")
                print("button:")
                print(cardButtons.index(of: button)!)
                button.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                button.setTitle("", for: .normal)
            }
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

