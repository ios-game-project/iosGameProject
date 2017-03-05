//
//  DrawingView.swift
//  SpriteKitGame
//
//  Created by leo  luo on 2017-03-04.
//  Copyright © 2017 iMac03. All rights reserved.
//

import UIKit

// special view to draw the circles
class DrawingView: UIView {
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    private var path: CGPath?
    private var fitResult: CircleResult?
    private var isCircle = false
    
    var drawDebug = false // set to true show additional information about the fit
    
    func updateFit(fit: CircleResult?, madeCircle: Bool) {
        fitResult = fit
        isCircle = madeCircle
        setNeedsDisplay()
    }
    
    func updatePath(p: CGPath?) {
        //print("update Path")
        path = p
        setNeedsDisplay()
    }
    
    func clear() {
        //print("clear drawing")
        updateFit(fit: nil, madeCircle: false)
        updatePath(p: nil)
    }
    
    override func draw(_ rect: CGRect) {
        if let path = path { // draw a thick yellow line for the user touch path
            let context = UIGraphicsGetCurrentContext()
            context!.addPath(path)
            context!.setStrokeColor(UIColor.yellow.cgColor)
            context!.setLineWidth(10)
            context?.setLineCap(CGLineCap.round)
            context?.setLineJoin(CGLineJoin.round)
            context!.strokePath()
        }
        
        //    if let fit = fitResult, drawDebug { // if there is a fit and drawDebug is turned on
        //      if !fit.error.isNaN { // if error has been defined, draw the fit
        //        let fitRect = CGRect(
        //          x: fit.center.x - fit.radius,
        //          y: fit.center.y - fit.radius,
        //          width: 2 * fit.radius,
        //          height: 2 * fit.radius
        //        )
        //        let fitPath = UIBezierPath(ovalIn: fitRect)
        //        fitPath.lineWidth = 3
        //
        //        // fit is the circle (green if the circle matched, red was the fit circle but did not recognize as a circle)
        //        let circleColor = isCircle ? UIColor.green : UIColor.red
        //        circleColor.setStroke()
        //        fitPath.stroke()
        //      }
        //
        //      // draw a black bounding box around the user touch path
        //      let boundingBox = UIBezierPath(rect: path!.boundingBox)
        //      boundingBox.lineWidth = 1
        //      UIColor.black.setStroke()
        //      boundingBox.stroke()
        //
        //      // draw a blue square inside as the touch exclusion area
        //      let fitInnerRadius = fit.radius / sqrt(2)
        //      let innerBoxRect = CGRect(
        //        x: fit.center.x - fitInnerRadius,
        //        y: fit.center.y - fitInnerRadius,
        //        width: 2 * fitInnerRadius,
        //        height: 2 * fitInnerRadius
        //      )
        //      let modifiedInnerBox = innerBoxRect.insetBy(dx: fitInnerRadius*0.2, dy: fitInnerRadius*0.2)
        //
        //      let innerBox = UIBezierPath(rect: modifiedInnerBox)
        //      UIColor.blue.withAlphaComponent(0.5).setFill()
        //      innerBox.fill()
        //    }
    }
}
