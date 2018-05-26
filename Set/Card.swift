//
//  Card.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import Foundation

/// hashable Card

struct Card: Hashable
{
    var isSelected = false
    var isVisible = false
    var isMatched = false
    
    var number: Int
    var symbol: Int
    var shading: Int
    var color: Int
    
    private var identifier: Int
    private static var identifierFactory = 0
    
    /// always return a unique number incrementing by 1
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    var hashValue: Int { return identifier  }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(number: Int, symbol: Int, shading: Int, color: Int) {
        self.identifier = Card.getUniqueIdentifier()
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
    
}
