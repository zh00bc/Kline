//
//  SolidLine.swift
//  kline
//
//  Created by zhangj on 2020/7/21.
//  Copyright © 2020 zhangj. All rights reserved.
//

import UIKit

class SolidLine: KLine {
    override init(type: LineType) {
        super.init(type: type)
        fillColor = UIColor.clear.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setNeedsDisplay() {

        let linePath = UIBezierPath()
        linePath.lineWidth = 1.0
        
        var moveToPoint = false
        if let lineDatas = points as? [LineData] {
            for point in lineDatas {
                if point.isNullData {
                    moveToPoint = false
                } else {
                    if moveToPoint {
                        linePath.addLine(to: CGPoint(x: point.x, y: point.y))
                    } else {
                        linePath.move(to: CGPoint(x: point.x, y: point.y))
                    }
                    moveToPoint = true
                }
            }
        }

        path = linePath.cgPath
    }
}
