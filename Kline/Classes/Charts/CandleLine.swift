//
//  CandleLine.swift
//  kline
//
//  Created by zhangj on 2020/7/21.
//  Copyright © 2020 zhangj. All rights reserved.
//

import UIKit

class CandleLine: KLine {
    
    let upRectLayer = CAShapeLayer()
    let upLineLayer = CAShapeLayer()
    let downRectLayer = CAShapeLayer()
    let downLineLayer = CAShapeLayer()
    
    let maxLabel = UILabel()
    let minLabel = UILabel()
    
    override func updateLineWidth(_ lineWidth: CGFloat) {
        super.updateLineWidth(lineWidth)
        
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
        upRectLayer.lineWidth = lineWidth
        downRectLayer.lineWidth = lineWidth

        if lineWidth == 1.0 {
            upLineLayer.lineWidth = 0.5
            downLineLayer.lineWidth = 0.5
        } else {
            upLineLayer.lineWidth = 1.0
            downLineLayer.lineWidth = 1.0
        }
        
//        CATransaction.commit()
    }
    
    
    override func setup() {
        upLineLayer.strokeColor = ColorManager.shared.kColorShadeButtonGreenEnd.cgColor
        upRectLayer.strokeColor = ColorManager.shared.kColorShadeButtonGreenEnd.cgColor
        downLineLayer.strokeColor = ColorManager.shared.kColorShadeButtonRedEnd.cgColor
        downRectLayer.strokeColor = ColorManager.shared.kColorShadeButtonRedEnd.cgColor
        
        maxLabel.textColor = ColorManager.shared.klineMinMaxValueColor
        minLabel.textColor = ColorManager.shared.klineMinMaxValueColor
        maxLabel.font = CustomFonts.DIN.medium.font(ofSize: 11)
        minLabel.font = CustomFonts.DIN.medium.font(ofSize: 11)
        
        addSublayer(upLineLayer)
        addSublayer(upRectLayer)
        addSublayer(downRectLayer)
        addSublayer(downLineLayer)
        addSublayer(maxLabel.layer)
        addSublayer(minLabel.layer)
    }
    
//    override func draw(in ctx: CGContext) {
//        ctx.saveGState()
//
//        var highCandle = CandleData()
//        var lowCandle = CandleData()
//        lowCandle.lowPrice = Double.greatestFiniteMagnitude
//        for (index, data) in points.enumerated() {
//            if let candle = data as? CandleData {
//                drawK(inContext: ctx, high: candle.highPoint, low: candle.lowPoint, open: candle.openPoint, close: candle.closePoint, candleWidth: lineWidth, lineWidth: 1)
//
//                if candle.highPrice > highCandle.highPrice {
//                    highCandle = candle
//                }
//                if candle.lowPrice < lowCandle.lowPrice {
//                    lowCandle = candle
//                }
//            }
//        }
//
//        if lowCandle.lowPrice < Double.greatestFiniteMagnitude {
//            drawHigh(highCandle, low: lowCandle)
//        }
//
//        ctx.restoreGState()
//    }

    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        let upRectPath = UIBezierPath()
        let upLinePath = UIBezierPath()
        let downRectPath = UIBezierPath()
        let downLinePath = UIBezierPath()
        var highCandle = CandleData()
        var lowCandle = CandleData()
        lowCandle.lowPrice = NSNumber(value: Double.greatestFiniteMagnitude)
        for point in points {
            if let candle = point as? CandleData {
                if candle.highPrice.compare(highCandle.highPrice) == .orderedDescending {
                    highCandle = candle
                }
                if candle.lowPrice.compare(lowCandle.lowPrice) == .orderedAscending {
                    lowCandle = candle
                }
                
                if candle.closePoint.y <= candle.openPoint.y {
                    upLinePath.move(to: candle.lowPoint)
                    upLinePath.addLine(to: candle.highPoint)
                    upRectPath.move(to: candle.openPoint)
                    upRectPath.addLine(to: candle.closePoint)
                } else {
                    downLinePath.move(to: candle.lowPoint)
                    downLinePath.addLine(to: candle.highPoint)
                    downRectPath.move(to: candle.openPoint)
                    downRectPath.addLine(to: candle.closePoint)
                }
            }
        }

        upLineLayer.path = upLinePath.cgPath
        upRectLayer.path = upRectPath.cgPath
        downLineLayer.path = downLinePath.cgPath
        downRectLayer.path = downRectPath.cgPath

        if lowCandle.lowPrice.compare(NSNumber(value: Double.greatestFiniteMagnitude)) == .orderedAscending {
            drawHigh(highCandle, low: lowCandle)
        }
    }
    
//    func drawK(inContext context: CGContext, high: CGPoint, low: CGPoint, open: CGPoint, close: CGPoint, candleWidth: CGFloat, lineWidth: CGFloat) {
//        context.setShouldAntialias(false)
//
//        if open.y < close.y {
//            context.setStrokeColor(ColorManager.shared.kColorShadeButtonRedEnd.cgColor)
//        } else {
//            context.setStrokeColor(ColorManager.shared.kColorShadeButtonGreenEnd.cgColor)
//        }
//
//        context.setLineWidth(lineWidth)
//        context.strokeLineSegments(between: [high, low])
//
//        context.setLineWidth(candleWidth)
//        context.strokeLineSegments(between: [open, close])
//    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        upRectLayer.frame = bounds
        upLineLayer.frame = bounds
        downRectLayer.frame = bounds
        downLineLayer.frame = bounds
    }
        
    func drawHigh(_ high: CandleData, low: CandleData) {
        let width: CGFloat = 200
        let height: CGFloat = 10.0
        let yOffset: CGFloat = 6.0
        
        let highText = KLineNumberFormatter.format(high.highPrice, precision: pricePrecision)
        let lowText = KLineNumberFormatter.format(low.lowPrice, precision: pricePrecision)
        
        if high.highPoint.x - width > 0 {
            maxLabel.text = "\(highText)—"
            maxLabel.frame = CGRect(x: high.highPoint.x - width, y: high.highPoint.y - yOffset, width: width, height: height)
            maxLabel.textAlignment = .right
        } else {
            maxLabel.text = "—\(highText)"
            maxLabel.frame = CGRect(x: high.highPoint.x, y: high.highPoint.y - yOffset, width: width, height: height)
            maxLabel.textAlignment = .left
        }
        
        if low.lowPoint.x - width > 0 {
            minLabel.text = "\(lowText)—"
            minLabel.frame = CGRect(x: low.lowPoint.x - width, y: low.lowPoint.y - yOffset, width: width, height: height)
            minLabel.textAlignment = .right
        } else {
            minLabel.text = "—\(lowText)"
            minLabel.frame = CGRect(x: low.lowPoint.x, y: low.lowPoint.y - yOffset, width: width, height: height)
            minLabel.textAlignment = .left
        }
    }
}
