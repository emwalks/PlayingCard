//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Emma Walker - TVandMobile Platforms - Core Engineering on 04/09/2019.
//  Copyright © 2019 Emma Walker - TVandMobile Platforms - Core Engineering. All rights reserved.
//

// this is my model

import Foundation

struct PlayingCard: CustomStringConvertible {
    
    var description: String { return "\(rank)\(suit)"}
    
    var suit: Suit
    var rank: Rank
    
    // raw values in an enum
    // you can associate a fixed constant raw value for every one of your cases
    // raw values are mostly for backwards compatability (in obj-c raw values were just ints)
    
    enum Suit: String, CustomStringConvertible {
        
        var description: String
        
        case spades = "♠️"
        case clubs = "♣️"
        case hearts = "♥️"
        case diamonds = "♦️"
        
        static var all = [Suit.spades,.clubs,.hearts,.diamonds]

    }
    

    
    // can write each case but here we are going to do an example of associated values
    
    enum Rank: CustomStringConvertible {
        
        var description: String
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int{
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0

            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"),.face("Q"),.face("K")]
            return allRanks
        }
    }
}
