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
    var cards = [Card]()
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Set.chooseCard(at index:\(index) is not in the deck")
        print(cards[index])
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
