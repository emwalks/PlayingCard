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
    
    var description: String { return "\(rank) \(suit)"}
    
    var suit: Suit //this is a variable which implements the enum Suit
    var rank: Rank //this is a variable which implements the enum Rank
    
    // you can associate a fixed constant raw value for every one of your cases
    // raw values are mostly for backwards compatability (in obj-c raw values were just ints)
    // raw values for enums are all of the same type
    // associated values for enums can be different types
    
    enum Suit: String, CustomStringConvertible {
        
        var description: String { return rawValue}
        
        case spades = "♠️"
        case clubs = "♣️"
        case hearts = "♥️"
        case diamonds = "♦️"
        
        //this var is an array of all the cases in the enum
        //swift can infer from the first entry that this is an array of suit so only need suit. once
        static var all = [Suit.spades,.clubs,.hearts,.diamonds]
        
    }
    
    // can write each case but here we are going to do an example of associated values
    // not the most elegant way to do it but for learning purposes
    // note in playing cards, pips are small symbols on the front side of the cards that determine the suit of the card and its rank.
    
    enum Rank: CustomStringConvertible {
        
        case ace
        case face(String)
        case numeric(Int)
        
        //this is a var that matches enumeration values using switch statement
        //if the case is X then give Y
        // you can use where with switch to check additional conditions
        //we need a default at the end because we are using where but not exhastive
        
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
        
        //this var all will be an array of type Rank
        
        static var all: [Rank] {
            //this adds an ace to an array called allRanks
            var allRanks = [Rank.ace]
            //this adds a card from 2-10 into allRanks array
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            //this adds each face card to the allRanks array
            allRanks += [Rank.face("J"),.face("Q"),.face("K")]
            
            // the var all now returns the array of allRanks
            return allRanks
        }
       
        //this is the description for custom string convertible to pull out rank
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
    }
}
