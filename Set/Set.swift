//
//  Set.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import Foundation

struct Set
{
    var cards = [Card]()
    private let totalCards = 81
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Set.chooseCard(at index:\(index) is not in the deck")
        print("chosen card at index: \(index) and identifier \(cards[index])")
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
    
    init() {
        makeDeck()
    }
    
}
