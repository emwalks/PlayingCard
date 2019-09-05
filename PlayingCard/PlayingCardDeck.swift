//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Emma Walker - TVandMobile Platforms - Core Engineering on 04/09/2019.
//  Copyright © 2019 Emma Walker - TVandMobile Platforms - Core Engineering. All rights reserved.
//

import Foundation

struct PlayingCardDeck
{
    // this is an array of playingCards
    // its private set var
    private(set) var cards = [PlayingCard]()
    
    init() {
        
        // the deck is initialised with playing cards for each suit of each rank which are added into the array
        // note Suit and Rank are both nested in PlayingCard so need that before
        
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    // this is a function that pulls a playing card out of the array if there are cards in the array
    // it's an optional because the array might be empty
    //its a mutating func because this is a struct but the return cards.remove(at: cards.count.arc4random changes the struct

    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}

//this extends the collection int to use arc4random (random number generator that takes a unsigned 32 bit integer)
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
