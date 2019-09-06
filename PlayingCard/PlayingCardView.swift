//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Emma Walker - TVandMobile Platforms - Core Engineering on 05/09/2019.
//  Copyright © 2019 Emma Walker - TVandMobile Platforms - Core Engineering. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        //to start just draw a circle in core graphics. To use core graphics we get the context first
        // start/end angle sre in radians
        // 0 is off to the right
        // when you run this block you will see you will get the stroke path in red but you don't get the fillpath - this is because you have consumed your path!
       
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath()
//            context.fillPath()
//        }
//
        //here we have re-written lines 19 - 26 above using BezierPath (slightly different nomenclature
        //after you say path.stroke you have not consumed your UI Bezier Path
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        UIColor.purple.setFill()
        UIColor.blue.setStroke()
        path.stroke()
        path.fill()
        
        //when you rotate you end up with an oval! Want to recall when bounds change
        // in Main.storyboard we set the content mode in the attribute inspector for our view to to redraw
    }
    
    
}
