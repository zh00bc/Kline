//
//  CALayer+Chart.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit
import CoreGraphics

enum LineType: Int {
    case solid = 0
    case candle = 1
    /// 交易量柱状图
    case columnar = 2
    /// 分时线
    case area = 3
    /// macd柱状图
    case separateColumnar = 4
    /// 分时线交易量柱状图
    case minuteColumnar = 5
}

class KLine: CAShapeLayer {
    
    var points: [KLineData] = []
    let lineType: LineType
    var pricePrecision: Int = 2
    var kLineWidth: CGFloat = 7.0
    var index: Int = 0
    
    
    init(type: LineType) {
        self.lineType = type
        super.init()
        contentsScale = UIScreen.main.scale
        backgroundColor = UIColor.clear.cgColor
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func action(forKey event: String) -> CAAction? {
        return nil
    }
    
    func updateLineWidth(_ lineWidth: CGFloat) {
        self.kLineWidth = lineWidth
    }
    
    func setup() {
        
    }
    
    func drawCubicLine(inContext context: CGContext, curX: Double, curY: Double, prevX: Double, prevY: Double, prevPrevX: Double, prevPrevY: Double, nextX: Double, nextY: Double) {
        let intensity = 0.10
        let prevDx = (curX - prevPrevX) * intensity
        let prevDy = (curY - prevPrevY) * intensity
        let curDx = (nextX - prevX) * intensity
        let curDy = (nextY - prevY) * intensity
        
        context.addCurve(
            to: CGPoint(
                x: curX,
                y: curY),
            control1: CGPoint(
                x: prevX + prevDx,
                y: prevY + prevDy),
            control2: CGPoint(
                x: curX - curDx,
                y: curY - curDy))
    }
    
    func getCandleClosePoint(by point: CGPoint) -> LineData {
        
        var cur = LineData()
        var next = LineData()
        var nextIndex = 0
        let pointX = Double(point.x)
        
        for index in 0..<points.count {
            nextIndex = index + 1 < points.count ? index + 1 : index
            
            if let candles = points as? [CandleData] {
                cur = candles[index].getClosePoint()
                next = (points[nextIndex] as! CandleData).getClosePoint()
            } else if let lines = points as? [LineData] {
                cur = lines[index]
                next = lines[nextIndex]
            }
            
            if cur.x < pointX {
                if next.x >= pointX {
                    if pointX - cur.x >= next.x - pointX {
                        return next
                    } else {
                        return cur
                    }
                }
            }
        }
        
        if let candles = points as? [CandleData] {
            return candles.last!.getClosePoint()
        }
        if let lines = points as? [LineData] {
            return lines.last!
        }
        return LineData()
    }
}
