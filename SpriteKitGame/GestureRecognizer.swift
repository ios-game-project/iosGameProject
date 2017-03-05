//
//  GestureRecognizer.swift
//  SpriteKitGame
//
//  Created by leo  luo on 2017-03-03.
//  Copyright © 2017 iMac03. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class GestureRecognizer: UIGestureRecognizer {
    
    private var touchedPoints = [CGPoint]() // point history
    
    var cFitResult = CircleResult() // information about how circle-like is the path
    var vFitResult = VerticalResult()
    var tolerance: CGFloat = 0.5 // circle wiggle room 抖动动值
    var isCircle = false
    var isVertical = false
    
    var lastPoint = CGPoint.zero
    
    var path = CGMutablePath() // running CGPath - helps with drawing
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent)  {
        super.touchesBegan(touches, with: event)
        // only one finger gesture is accepted
        if touches.count != 1 {
            state = .failed
        }
        
        let window = view?.window
        if let loc = touches.first?.location(in: window) {
            path.move(to: CGPoint(x:loc.x, y:loc.y)) // start the path
        }
        touchedPoints.removeAll()
        state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        //state = .ended
        
        // now that the user has stopped touching, figure out if the path was a circle
        cFitResult = fitCircle(points: touchedPoints)
        vFitResult = fitVertical(points: touchedPoints)
        
        // make sure there are no points in the middle of the circle
        //let hasInside = anyPointsInTheMiddle()
        
        //let percentOverlap = calculateBoundingOverlap()
        
        
        //print(cFitResult.error)
        //print(hasInside)
        //print(percentOverlap)
        //print("error: \(vFitResult.error)")
        //print(vFitResult.isLine)
        //print("*********************")
        
        //isCircle = cFitResult.error <= tolerance && !hasInside //&& percentOverlap > (1-tolerance)
        
        isVertical = (vFitResult.error < 10.0) && vFitResult.isLine
        
        //state = isCircle ? .ended : .failed
        state = isVertical ? .ended : .failed
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if (state == .failed){
            return
        }
        // To make the math easy, convert the tracked points to window coordinates. This makes it easier to track touches that don’t line up within any particular view, so the user can make a circle outside the bounds of the image, and have it still count towards selecting that image.
        let window = view?.window
        //if let touches = touches as? Set<UITouch>, loc = touches.first?.locationInView(window) {
        if let loc = touches.first?.location(in: window) {
            //print(loc)
            touchedPoints.append(loc)
            path.addLine(to: loc)
            
            //drawLines(fromPoint: lastPoint, toPoint: loc)
            lastPoint = loc
            state = .changed
        }
        
        
//        if let touch = touches.first {
//            let currentPoint = touch.location(in: self.view)
//            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
//            
//            lastPoint = currentPoint
//        }
    }
    /*
    private func anyPointsInTheMiddle() -> Bool {
        // 1
        let fitInnerRadius = cFitResult.radius / sqrt(2) * tolerance
        // 2
        let innerBox = CGRect(
            x: cFitResult.center.x - fitInnerRadius,
            y: cFitResult.center.y - fitInnerRadius,
            width: 2 * fitInnerRadius,
            height: 2 * fitInnerRadius)
        
        // 3
        var hasInside = false
        for point in touchedPoints {
            if innerBox.contains(point) {
                hasInside = true
                break
            }
        }
        
        return hasInside
    }
    
    private func calculateBoundingOverlap() -> CGFloat {
        // 1
        let fitBoundingBox = CGRect(
            x: cFitResult.center.x - cFitResult.radius,
            y: cFitResult.center.y - cFitResult.radius,
            width: 2 * cFitResult.radius,
            height: 2 * cFitResult.radius)
        let pathBoundingBox = path.boundingBox
        
        // 2
        let overlapRect = fitBoundingBox.intersection(pathBoundingBox)
        
        // 3
        let overlapRectArea = overlapRect.width * overlapRect.height
        let circleBoxArea = fitBoundingBox.height * fitBoundingBox.width
        
        let percentOverlap = overlapRectArea / circleBoxArea
        return percentOverlap
    }*/
    
}

