//
//  CircleFit.swift
//  SpriteKitGame
//
//  Created by leo  luo on 2017-03-03.
//  Copyright © 2017 iMac03. All rights reserved.
//

import Foundation
import UIKit

struct VerticalResult {
    var begin: CGPoint
    var end: CGPoint
    var error: Double
    var numOfIteration: Int
    var isLine = false
    
    init() {
        begin = CGPoint(x: 0,y :0)
        end = CGPoint(x: 0,y :0)
        error = 0
        numOfIteration = 0
    }
}

func fitVertical(points: [CGPoint]) -> VerticalResult {
    let dataLength: CGFloat = CGFloat(points.count)
    var mean: CGPoint = CGPoint(x: 0,y :0)
    
    let beginPoint: CGPoint = points[0]
    let endPoint: CGPoint = points[ Int(dataLength - 1) ]
    
    for p in points {
        mean.x += p.x
        mean.y += p.y
    }
    mean.x = mean.x / dataLength
    mean.y = mean.y / dataLength
    
    // 向量Vector a的(x, y)坐标
    let va_x = beginPoint.x - mean.x;
    let va_y = beginPoint.y - mean.y;
    
    // 向量b的(x, y)坐标
    let vb_x = endPoint.x - mean.x;
    let vb_y = endPoint.y - mean.y;
    
    let productValue = (va_x * vb_x) + (va_y * vb_y);  // 向量的乘积
    let va_val = sqrt(va_x * va_x + va_y * va_y);  // 向量a的模
    let vb_val = sqrt(vb_x * vb_x + vb_y * vb_y);  // 向量b的模
    let cosValue = productValue / (va_val * vb_val);      // 余弦公式
    
    let angle = Double(acos(cosValue) * 180) / M_PI;
    print("angle: \(angle)")
    
    var vertical = VerticalResult()
    vertical.begin.x = beginPoint.x
    vertical.begin.y = beginPoint.y
    vertical.end.x = endPoint.x
    vertical.end.y = endPoint.y
    if((180 - angle) < 5){ vertical.isLine = true }
    vertical.error = abs(Double(beginPoint.x) - Double(endPoint.x))
    return vertical
    
}

