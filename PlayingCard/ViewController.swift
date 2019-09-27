//
//  ViewController.swift
//  PlayingCard
//
//  Created by Emma Walker - TVandMobile Platforms - Core Engineering on 04/09/2019.
//  Copyright © 2019 Emma Walker - TVandMobile Platforms - Core Engineering. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck ()
    
    @IBOutlet weak var playingCardView: PlayingCardView!{
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            playingCardView.addGestureRecognizer(pinch)
            
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            UIView.transition(
                with: playingCardView,
                duration: 0.6,
                options: [.transitionFlipFromLeft],
                animations: {self.playingCardView.isFaceUp = !self.playingCardView.isFaceUp}
            )
        default: break
        }
    }
    
    //we need to add @obj-c to expose the function to obj-c, as the underlying framework for target action is onjc
    @objc func nextCard(){
        // if because the deck may be empty
        if let card = deck.draw() {
            //heres where the controller is converting between the model and the view
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
}

