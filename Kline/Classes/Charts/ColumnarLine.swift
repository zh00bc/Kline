//
//  ColumnarLine.swift
//  kline
//
//  Created by zhangj on 2020/7/21.
//  Copyright © 2020 zhangj. All rights reserved.
//

import UIKit

class ColumnarLine: KLine {
    let upLayer = CAShapeLayer()
    let downLayer = CAShapeLayer()
    
    override func setup() {
        super.setup()
        if lineType == .minuteColumnar {
            upLayer.strokeColor = ColorManager.shared.klineMinuteVolumeColor.cgColor
            downLayer.strokeColor = ColorManager.shared.klineMinuteVolumeColor.cgColor
        } else {
            upLayer.strokeColor = ColorManager.shared.kColorShadeButtonGreenEnd.cgColor
            downLayer.strokeColor = ColorManager.shared.kColorShadeButtonRedEnd.cgColor
        }
        
        addSublayer(upLayer)
        addSublayer(downLayer)
    }
    
//    override func draw(in ctx: CGContext) {
//        for data in points {
//            if let columnar = data as? ColumnarData {
//                draw(inContext: ctx, high: columnar.highPoint, low: columnar.lowPoint, color: ColorManager.shared.kColorShadeButtonGreenEnd)
//            }
//        }
//    }
    
//    func draw(inContext context: CGContext, high: CGPoint, low: CGPoint, color: UIColor) {
//        context.setShouldAntialias(false)
//        context.setStrokeColor(color.cgColor)
//        context.setLineWidth(lineWidth)
//        context.strokeLineSegments(between: [low, high])
//    }
    
    override func updateLineWidth(_ lineWidth: CGFloat) {
        super.updateLineWidth(lineWidth)
        if lineType == .separateColumnar {
            upLayer.lineWidth = 0.6
            downLayer.lineWidth = 0.6
        } else if lineType == .minuteColumnar {
            upLayer.lineWidth = 1.5
            downLayer.lineWidth = 1.5
        } else {
            upLayer.lineWidth = lineWidth
            downLayer.lineWidth = lineWidth
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        upLayer.frame = bounds
        downLayer.frame = bounds
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        if let lineDatas = points as? [ColumnarData] {
            
            let upLine = UIBezierPath()
            let downLine = UIBezierPath()

            let ups = lineDatas.filter({ $0.priceUp })
            let downs = lineDatas.filter({ !$0.priceUp })
            
            if !ups.isEmpty {
                for point in ups {
                    if !point.isNullData {
                        upLine.move(to: point.lowPoint)
                        upLine.addLine(to: point.highPoint)
                    }
                }
            }
            
            if !downs.isEmpty {
                for point in downs {
                    if !point.isNullData {
                        downLine.move(to: point.lowPoint)
                        downLine.addLine(to: point.highPoint)
                    }
                }
            }
            
            upLayer.path = upLine.cgPath
            downLayer.path = downLine.cgPath
        }
    }
}
