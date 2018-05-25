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
    private var selectedCards = [Int]()
    
    mutating func makeCardVisible(by index: Int){
        cards[index].isVisible = true
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Set.chooseCard(at index:\(index) is not in the deck")
        if selectedCards.count < 3 {
            // toggle and store selected cards
            handleSelectedCard(at: index)
        }
        if selectedCards.count == 3{
            // evaluate correctness of selected cards
            let hasSet = evaluateSet()
            if hasSet {
                // reset selectedCards
                selectedCards.removeAll()
                // increment score
                score += 1
                // TODO: if correct do something on ui, if not do something on ui
                // TODO: add three more cards automatically
                // TODO: add point to score
            } else {
               print("sorry, you dont have a Set~")
            }
        }
    }
    
    private func evaluateSet() -> Bool {
        print("evaluating...")
        // get three selected cards
        let cardOne = cards[selectedCards[0]]
        let cardTwo = cards[selectedCards[1]]
        let cardThree = cards[selectedCards[2]]
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
                        print("you have a Set~")
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
    
    mutating private func handleSelectedCard(at index: Int){
        // toggle isSelected
        cards[index].isSelected = !cards[index].isSelected
        // save selected if visible
        if cards[index].isSelected && cards[index].isVisible {
            selectedCards.append(index)
        }else {
            // remove unselected
            if let selected = selectedCards.index(of: index) {
                selectedCards.remove(at: selected)
            }
        }
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
    
    mutating private func shuffleDeck() {
        for _ in 0..<cards.count {
            cards.sort(by: {_,_ in arc4random() > arc4random()})
        }
    }
    
    init() {
        makeDeck()
        shuffleDeck()
    }
    
}
