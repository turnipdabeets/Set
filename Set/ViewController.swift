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
    var visibleCards = [Card]()
    lazy var totalButtonsAvailable = cardButtons.count
    var hasMatch = false
    
    
    @IBAction func dealThreeMore(_ sender: UIButton) {
        
        if hasMatch {
            
        } else {
            //TODO: make sure no set exists before allow dealing more?
            if visibleCards.count < totalButtonsAvailable {
                let lastVisibleCardIndex = visibleCards.count
                for index in 0..<3 {
                    if let card = game.draw() {
                        visibleCards.append(card)
                        style(a: cardButtons[index + lastVisibleCardIndex], by: card)
                    } else {
                        print("ran out of cards in the deck!")
                    }
                }
                
            } else{
                print("can't deal anymore cards, no room on screen!")
            }
        }

    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            // select card
            game.touch(card: visibleCards[index])
            // check for match
            checkForMatch()
        }
    }
    
    func checkForMatch(){
        if let matchedCards = game.checkForMatch() {
            for card in matchedCards {
                if let index = visibleCards.index(of: card){
                    // draw new card
                    if let newCard = game.draw() {
                        // replace old card with newCard
                        visibleCards[index] = newCard
                        style(a: cardButtons[index], by: newCard)
                    } else {
                        // ran out of cards in the deck!
                        hideButton(by: index)
                    }
                }
            }
        }
    }
    
    
//    // draw new card
//    if let newCard = game.draw() {
//        if let index = visibleCards.index(of: card){
//            // replace old card with newCard
//            visibleCards[index] = newCard
//            style(a: cardButtons[index], by: newCard)
//        }
//    } else {
//    // ran out of cards in the deck!
//    if let index = visibleCards.index(of: card){
//    hideButton(by: index)
//    }
//    }
    
//    if game.cards.count == 0 {
//    // nothing left to swap
//    if let index = visibleCards.index(of: card){
//    hideButton(by: index)
//    }
//    } else {
//    // draw new card
//    if let newCard = game.draw() {
//    if let index = visibleCards.index(of: card){
//    // replace old card with newCard
//    visibleCards[index] = newCard
//    style(a: cardButtons[index], by: newCard)
//    }
//    } else {
//    print("ran out of cards in the deck!")
//    }
//    }
    
//    if let index = visibleCards.index(of: card){
//        // no visible space to swap for new card so "hide"
//        if game.cards.count < visibleCards.count {
//            hideButton(by: index)
//        } else {
//            // draw new card
//            if let newCard = game.draw() {
//                // replace old card with newCard
//                visibleCards[index] = newCard
//                style(a: cardButtons[index], by: newCard)
//            } else {
//                print("ran out of cards in the deck!")
//            }
//        }
//    }
    
    func hideButton(by index: Int){
        let button = cardButtons[index]
        button.setAttributedTitle(NSAttributedString(string:""), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
//
        
//            // clear old cards before selecting new one
//            if game.selectedCards.count == 3 && !hasMatch {
//                resetCardsStyle()
//                game.clearOutSelectedCards()
//            }
//
//            // only take action if card pressed is "visible" and do no have a match
//            if visibleButtons.contains(index) && !hasMatch{
//                // handle selection or deselection logic
//                game.touchCard(at: index)
//                // handle selection or deselection style
//                styleTouched(button: sender, by: game.cards[index])
//                // TODO: evalutate if match
//                if game.selectedCards.count == 3 {
//                    let hasSet = game.evaluateSet()
//                    if hasSet {
//                        hasMatch = true
////                        game.saveMatch()
//                    } else {
//                        hasMatch = false
//                        game.selectedCards.forEach({(card) in
//                            if let index = game.cards.index(of: card){
//                                cardButtons[index].layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//                            }
//                        })
//                    }
//                }
////                let match = game.checkMatch()
//                // TODO: if correct do something on ui, if not do something on ui
//                // TODO: handle less cards than visible buttons
//                //TODO: only allow pressing after hanlding match
//                // TODO: remove styles from matched after handling
//            }
//        }
//    }
    
//    func resetCardsStyle(){
//        for card in game.selectedCards {
//            if let index = game.cards.index(of: card){
//                let button = cardButtons[index]
//                let resetCard = game.unselectCard(by: index)
//                styleTouched(button: button, by: resetCard)
//            }
//        }
//    }

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
            // set up buttons with 12 cards
            for index in 0..<12 {
                if let card = game.draw() {
                    visibleCards.append(card)
                    style(a: cardButtons[index], by: card)
                }
            }
        }
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

