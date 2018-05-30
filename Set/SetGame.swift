//
//  Set.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import Foundation

/// make a desk of cards with number, symbol, shading & color by Int 0-2
struct SetGame
{
    private(set) var cards = [Card]()
    private(set) var score = 0
    private(set) var matchedCards = [Card]()
    private(set) var selectedCards = [Card]()
    
    mutating func touchCard(at index: Int) {
        assert(cards.indices.contains(index), "Set.chooseCard(at index:\(index) is not in the deck")
        if selectedCards.count < 3 {
            // toggle and store selected cards
            handleSelectedCard(at: index)
        }
    }
    
    mutating func unselectCard(by index: Int) -> Card {
       cards[index].isSelected = false
        return cards[index]
    }
    
    mutating func clearOutSelectedCards(){
        // reset selectedCards
        selectedCards.removeAll()
    }
    
    mutating func getNewCards(){
        selectedCards.forEach({(card: Card) -> Void in
            // remove old card from deck & replace with a new card
            for new in stride(from: cards.count - 1, to: 0, by: -1) {
                if let previous = cards.index(of: card) {
                    // swap cards
                    if !matchedCards.contains(cards[new]) {
                        cards.swapAt(new, previous)
                        break;
                    }
                }
            }
            return
        })
//        print("matchedCards", matchedCards)

    }
    
    mutating func saveMatch() {
        // save matches
        matchedCards += selectedCards
        // increment score
        score += 1
        print("matchedCards")
        print(matchedCards.map({$0.identifier}))
    }
    
    mutating private func handleSelectedCard(at index: Int){
        // toggle isSelected
        cards[index].isSelected = !cards[index].isSelected
        let card = cards[index]
        if let selected = selectedCards.index(of: card) {
        // remove unselected
            selectedCards.remove(at: selected)
        } else {
        // save selected
            selectedCards.append(card)
        }
    }
    
    func evaluateSet() -> Bool {
        // get three selected cards
        let cardOne = selectedCards[0]
        let cardTwo = selectedCards[1]
        let cardThree = selectedCards[2]
        // get set cases
        let allTheSameNumber = allTheSame(itemOne: cardOne.number, itemTwo: cardTwo.number, itemThree: cardThree.number)
        let allDifferentNumber = allDifferent(itemOne: cardOne.number, itemTwo: cardTwo.number, itemThree: cardThree.number)
        let allTheSameColor = allTheSame(itemOne: cardOne.color, itemTwo: cardTwo.color, itemThree: cardThree.color)
        let allDifferentColor = allDifferent(itemOne: cardOne.color, itemTwo: cardTwo.color, itemThree: cardThree.color)
        let allTheSameSymbol = allTheSame(itemOne: cardOne.symbol, itemTwo: cardTwo.symbol, itemThree: cardThree.symbol)
        let allDifferentSymbol = allDifferent(itemOne: cardOne.symbol, itemTwo: cardTwo.symbol, itemThree: cardThree.symbol)
        let allTheSameShading = allTheSame(itemOne: cardOne.shading, itemTwo: cardTwo.shading, itemThree: cardThree.shading)
        let allDifferentShading = allDifferent(itemOne: cardOne.shading, itemTwo: cardTwo.shading, itemThree: cardThree.shading)
        // check set cases
        if allTheSameNumber || allDifferentNumber {
            if allTheSameColor || allDifferentColor {
                if allTheSameSymbol || allDifferentSymbol {
                    if allTheSameShading || allDifferentShading {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func allTheSame(itemOne: Int, itemTwo: Int, itemThree:Int) -> Bool {
        return itemOne == itemTwo && itemTwo == itemThree
    }
    
    private func allDifferent(itemOne: Int, itemTwo: Int, itemThree:Int) -> Bool {
        return itemOne != itemTwo && itemTwo != itemThree && itemThree != itemOne
    }
    
    mutating private func makeDeck(){
        let cardOptionRange = 0..<3
        for number in cardOptionRange {
            for symbol in cardOptionRange {
                for shading in cardOptionRange {
                    for color in cardOptionRange {
                        let card = Card(number: number, symbol: symbol, shading: shading, color: color)
                        cards.append(card)
                    }
                }
            }
        }
    }
    
    mutating private func testDeck(){
        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
        
    }
    
    mutating private func shuffleDeck() {
        for _ in 0..<cards.count {
            cards.sort(by: {_,_ in arc4random() > arc4random()})
        }
    }
    
    init() {
        testDeck()
//        makeDeck()
//        shuffleDeck()
    }
    
}
