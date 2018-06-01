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
    var misMacthed = [Card]()
    var matched = [Card]()
    
    @IBAction func dealThreeMore(_ sender: UIButton) {
        // recently had a match and more cards to deal
        if !matched.isEmpty && !game.cards.isEmpty {
            for card in matched {
                if let index = visibleCards.index(of: card){
                    // remove matched styles
                    removeStyleFrom(button: cardButtons[index])
                    // draw new card
                    if let newCard = game.draw() {
                        // swap with old card
                        replace(old: index, with: newCard)
                    } else {
                        // ran out of cards in the deck!
                        hideButton(by: index)
                    }
                }
            }
            matched.removeAll()
        } else {
            //TODO: make sure no set exists before allow dealing more?
            if visibleCards.count < totalButtonsAvailable {
                let lastVisibleCardIndex = visibleCards.count
                for index in 0..<3 {
                    if let card = game.draw() {
                        // add more visible cards
                        visibleCards.append(card)
                        style(a: cardButtons[index + lastVisibleCardIndex], by: card)
                    } else {
                        print("ran out of cards in the deck!")
                    }
                }
                
            } else {
                print("can't deal anymore cards, no room on screen!")
            }
        }
        // disable if we run out of cards
        if game.cards.isEmpty { disable(button: sender) }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        // must deal more cards if we have a match
        if !matched.isEmpty && !game.cards.isEmpty { return }
        // can no longer deal
        if !matched.isEmpty && game.cards.isEmpty {
            for card in matched {
                if let index = visibleCards.index(of: card){
                    
                    // remove from visible so it can no longer be selected??
                    
                    // hide by styles
                    removeStyleFrom(button: cardButtons[index])
                    hideButton(by: index)
                }
            }
            matched.removeAll()
        }
        
        // clear styles if mismatched cards
        clearMisMatchStyle()
        // select or deselect card
        if let index = cardButtons.index(of: sender) {
            if visibleCards.indices.contains(index) {
=                if cardButtons[index].isEnabled {
                    game.select(card: visibleCards[index])
                    styleTouched(button: cardButtons[index], by: visibleCards[index])
                }
            }
        }
        // check for match
        handleMatchedCards()
    }
    
    func disable(button sender: UIButton){
        sender.isEnabled = false
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func removeStyleFrom(button: UIButton){
        button.layer.borderWidth = 0.0
    }
    
    func clearMisMatchStyle(){
        if !misMacthed.isEmpty {
            for card in misMacthed {
                if let index = visibleCards.index(of: card){
                    // remove style
                    removeStyleFrom(button: cardButtons[index])
                }
            }
            misMacthed.removeAll()
        }
    }
    
    // TODO: move this logic to draw for styleTouched and replace old and new
    func handleMatchedCards(){
        if let matchedCards = game.checkForMatch() {
            matched += matchedCards
            game.clearSelectedCards()
            for card in matched {
                if let index = visibleCards.index(of: card){
                    // styles
                    let button = cardButtons[index]
                    button.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    button.layer.borderWidth = 6.0
                }
            }
        }else {
            if game.selectedCards.count == 3 {
                for card in game.selectedCards {
                    if let index = visibleCards.index(of: card){
                        // mark not match style
                        let button = cardButtons[index]
                        button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                        button.layer.borderWidth = 6.0
                    }
                }
                misMacthed = game.selectedCards
                game.clearSelectedCards()
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

