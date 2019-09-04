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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //nice place to write some quick testing code
        
        for _ in 1...10 {
            if let card = deck.draw() {
                print ("\(card)")
            }
        }
    }


}

