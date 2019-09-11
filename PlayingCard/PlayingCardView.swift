//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Emma Walker - TVandMobile Platforms - Core Engineering on 05/09/2019.
//  Copyright © 2019 Emma Walker - TVandMobile Platforms - Core Engineering. All rights reserved.
//

import UIKit

// by adding @IBDesignable we can see the PlayingCardView in the interface builder (main stroyboard) - it will be complied in the interface builder
// note however the images in assets will not be viewable if they are UIImage(named: ) need to add extra in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) as per below

@IBDesignable

class PlayingCardView: UIView
{

    // here we have defined rank and suit in a different way to the model - which is fine
    // it is the controllers job to interpret!
    // the didSet updates the drawing (setNeedsDisplay) and the subviews (setNeedsLayout) when these vars get updated
    
    //by adding IBInspectable
    
    @IBInspectable var rank: Int = 11 { didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable var suit: String = "♥️" { didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable var isFaceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay()} }
    
    // this function is going to handle my pinch gesture. rescales the faceCardImages
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            //this resets the scale - incremental changes
            recognizer.scale = 1.0
        default: break
        }
    }
    
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
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    lazy private var upperLeftCornerLabel = createCornerLabel()
    lazy private var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // by setting 0 we are saying use as many lines as required
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        //this is a trick to use with size to fit method (which is a label method) to clear out any frame.sizing prior to use
        label.frame.size = CGSize.zero
        label.sizeToFit()
        
        //we only draw these if the card isFaceUp
        label.isHidden = !isFaceUp
    }
    
    //this is to update view when e.g. the slider in settings updates
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    //this is like autolayout but in code for our subviews
    //it is a function that is called eventually by setNeedsLayout() {similar to draw(_ Rect) and setNeedsDisplay()} which we are now overridding (custom sub view)
    // in a subview bounds is where we draw
    // and frame is what positions it
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        
        //need to move these labels to the right place
        upperLeftCornerLabel.frame.origin  = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        //need to invert the number and rank
        //every view in iOS has a var called transform (affine transform = scale, translation, rotation pixel wise)
        //cant just roate by pi radians
        //It rotates around the subviews' origin (top LH corner, not centre of object) so also need a translate
        //here we translate by whole width and height
        //could also find centre and rotate and translate again
        
        lowerRightCornerLabel.transform = CGAffineTransform.identity.translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        
        //the lower right positioning is a bit trickier. Go to max and transform back 2 steps:
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
        
    }
    
    private func drawPips() {
        
        // this is data driven - for the number of pips place them in an array for the row
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        
        //this nested/imbedded function that creates the string and picks size depending on space available
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize /
                    (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        //this is the for loop that draws the pips in the row from the array and if there is 2 in the row it offsets them
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        //our card is going to be a rounded rect and we have clipped everything else into the rounded rect
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            //this will grab the image in assets by name and zooms based on parameters
            //the addition of in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) means you can see the assets image in main.storyboard
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                drawPips()
            }
        }
        else {
            if let cardBackImage = UIImage(named: "cardback") {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
    
}

// Extension with useful utilities
// This is how we do constants in Swift
// can replace the absolute numbers above with these extension values - e.g. fontSize and cornerRadius

extension PlayingCardView {
    
    // Ratios that determine the card's size
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.60
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
    
    // Gets the string representation of the current rank based on rank
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

// Extension to draw pips
extension CGRect {
    
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight) / 2)
    }
    
}


extension CGPoint {
    // Get a new point with the given offset
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
