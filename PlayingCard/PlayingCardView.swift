//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Emma Walker - TVandMobile Platforms - Core Engineering on 05/09/2019.
//  Copyright © 2019 Emma Walker - TVandMobile Platforms - Core Engineering. All rights reserved.
//

import UIKit

class PlayingCardView: UIView
{
    // here we have defined rank and suit in a different way to the model - which is fine
    //it is the controllers job to interpret!
    //the didSet updates the drawing (setNeedsDisplay) and the subviews (setNeedsLayout) when these vars get updated
    var rank: Int = 5 { didSet {setNeedsDisplay(); setNeedsLayout() } }
    var suit: String = "♥️" { didSet {setNeedsDisplay(); setNeedsLayout() } }
    var isFaceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        
        //using iOS preffered body font
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        
        //this is adding accessibility to app - scales fonts when changed in settings
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        //this deals with centering the font using a pre-exisiting class
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
        
    }
    
    // \n is new line in ASCII
    // need to extend playingcardview so that rank gives out a string
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: 16.0)
    }
    
    lazy private var upperLeftCornerLabel = createCornerLabel()
    lazy private var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    //this is like autolayout but in code for our subviews
    //it is a function that is called eventually by setNeedsLayout() {similar to draw(_ Rect) and setNeedsDisplay()} which we are now overridding (custom sub view)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }
    
    override func draw(_ rect: CGRect) {
        
        //our card is going to be a rounded rect and we have clipped everything else into the rounded rect
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        //now going to add the corners (rank and suit) using a UILabel
        //could also be done with NSattributed string in draw rect
        //learning about subviews, fonts
        
        
        
        
    }
    
    
}

// Extension with useful utilities
extension PlayingCardView {
    
    // Ratios that determine the card's size
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.95
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    // Gets the string representation of the current rank
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

