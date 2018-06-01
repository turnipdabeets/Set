//
//  ViewController.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

private class ViewController: UIViewController {
    var game = SetGame()
    var visibleCards = [Card]()
    var misMatched = [Card]()
    var matched = [Card]()
    
    @IBAction func dealThreeMore(_ sender: UIButton) {
        // have a match and cards available to deal
        if !matched.isEmpty && !game.cards.isEmpty {
            clearAndDeal()
        } else {
            // deal three more cards
            //TODO: make sure no set exists before allow dealing more?
            deal()
        }
        // disable if we run out of cards
        if game.cards.isEmpty { disable(button: sender) }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        // must deal more cards if we have a match first
        if !matched.isEmpty && !game.cards.isEmpty { return }
        
        // deal no longer possible
        if !matched.isEmpty && game.cards.isEmpty { clearAndDeal()}
        
        // reset any mismatched card styles
        if !misMatched.isEmpty { resetMisMatchedStyle() }
        
        // select or deselect card
        if let index = cardButtons.index(of: sender) { toggleCardSelection(by: index)}
        
        // check for match
        checkIfCardsMatch()
    }
    
    func toggleCardSelection(by index: Int){
        if visibleCards.indices.contains(index) {
            if cardButtons[index].isEnabled {
                game.select(card: visibleCards[index])
                styleTouched(button: cardButtons[index], by: visibleCards[index])
            }
        }
    }
    
    func disable(button sender: UIButton){
        sender.isEnabled = false
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func removeStyleFrom(button: UIButton){
        button.layer.borderWidth = 0.0
    }
    
    func clearAndDeal(){
        for card in matched {
            if let index = visibleCards.index(of: card){
                // remove matched styles
                removeStyleFrom(button: cardButtons[index])
                // draw new card
                if let newCard = game.drawCard() {
                    // swap with old card
                    replace(old: index, with: newCard)
                } else {
                    // ran out of cards in the deck!
                    hideButton(by: index)
                }
            }
        }
        matched.removeAll()
    }
    
    func deal(){
        if visibleCards.count < cardButtons.count {
            let lastVisibleCardIndex = visibleCards.count
            for index in 0..<3 {
                if let card = game.drawCard() {
                    // add more visible cards
                    visibleCards.append(card)
                    style(a: cardButtons[index + lastVisibleCardIndex], by: card)
                } else {
                    print("ran out of cards in the deck!")
                }
            }
        } else {
            print("ran out of button space")
        }
    }
    
    func resetMisMatchedStyle(){
        for card in misMatched {
            if let index = visibleCards.index(of: card){
                // remove style
                removeStyleFrom(button: cardButtons[index])
            }
        }
        misMatched.removeAll()
    }
    
    func checkIfCardsMatch(){
        if let matchedCards = game.matchedCards() {
            matched = matchedCards
            game.clearSelectedCards()
            styleMatchedCards()
        }else {
            if game.selectedCards.count == 3 {
                misMatched = game.selectedCards
                game.clearSelectedCards()
                styleMisMatchedCards()
            }
        }
    }
    
    func styleMatchedCards(){
        for card in matched {
            if let index = visibleCards.index(of: card){
                let button = cardButtons[index]
                button.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                button.layer.borderWidth = 6.0
            }
        }
    }
    
    func styleMisMatchedCards(){
        for card in misMatched {
            if let index = visibleCards.index(of: card){
                let button = cardButtons[index]
                button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                button.layer.borderWidth = 6.0
            }
        }
    }
    
    func replace(old index: Int, with newCard: Card){
        visibleCards[index] = newCard
        style(a: cardButtons[index], by: newCard)
    }
    
    func hideButton(by index: Int){
        let button = cardButtons[index]
        button.setAttributedTitle(NSAttributedString(string:""), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.isEnabled = false
    }
    
    func styleTouched(button: UIButton, by card: Card) {
        if game.selectedCards.contains(card) {
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            button.layer.borderWidth = 6.0
        }else {
            removeStyleFrom(button: button)
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            // set up buttons with 12 cards
            for index in 0..<12 {
                if let card = game.drawCard() {
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

