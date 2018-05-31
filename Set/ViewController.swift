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
    var misMacthedCards = [Card]()
    
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
            // clear styles if mismatched cards
            clearMisMatchStyle()
            // select or deselect card
            game.select(card: visibleCards[index])
            styleTouched(button: cardButtons[index], by: visibleCards[index])
            // check for match
            handleMatchedCards()
        }
    }
    
    func clearMisMatchStyle(){
        if !misMacthedCards.isEmpty {
            for card in misMacthedCards {
                if let index = visibleCards.index(of: card){
                    // remove style
                    let button = cardButtons[index]
                    button.layer.borderWidth = 0.0
                }
            }
            misMacthedCards.removeAll()
        }
    }
    
    // TODO: move this logic to draw for styleTouched and replace old and new
    func handleMatchedCards(){
        if let matchedCards = game.checkForMatch() {
            hasMatch = true
            game.clearSelectedCards()
            for card in matchedCards {
                if let index = visibleCards.index(of: card){
                    // remove styles
                    styleTouched(button: cardButtons[index], by: card)
                    // draw new card
                    if let newCard = game.draw() {
                        replace(old: index, with: newCard)
                    } else {
                        // ran out of cards in the deck!
                        hideButton(by: index)
                    }
                }
            }
        }else {
            hasMatch = false
            if game.selectedCards.count == 3 {
                print("no match")
                for card in game.selectedCards {
                    if let index = visibleCards.index(of: card){
                        // mark not match style
                        let button = cardButtons[index]
                        button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                        button.layer.borderWidth = 6.0
                    }
                }
                misMacthedCards = game.selectedCards
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
    }

    func styleTouched(button: UIButton, by card: Card) {
        print(game.selectedCards)
        if game.selectedCards.contains(card) {
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

