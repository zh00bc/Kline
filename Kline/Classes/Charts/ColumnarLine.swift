//
//  ColumnarLine.swift
//  kline
//
//  Created by zhangj on 2020/7/21.
//  Copyright © 2020 zhangj. All rights reserved.
//

import UIKit

class ColumnarLine: KLine {
//    @property(retain, nonatomic) CAShapeLayer *downLayer; // @synthesize downLayer=_downLayer;
//    @property(retain, nonatomic) CAShapeLayer *upLayer;
    
    let upLayer = CAShapeLayer()
    let downLayer = CAShapeLayer()
    
    override func setup() {
        super.setup()
        upLayer.strokeColor = ColorManager.shared.kColorShadeButtonGreenEnd.cgColor
        downLayer.strokeColor = ColorManager.shared.kColorShadeButtonRedEnd.cgColor
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
            let ups = lineDatas.filter({ $0.priceUp })
            let downs = lineDatas.filter({ !$0.priceUp })
            
            if !ups.isEmpty {
                let upLine = UIBezierPath()
                for point in ups {
                    upLine.move(to: point.lowPoint)
                    upLine.addLine(to: point.highPoint)
                }
                upLayer.path = upLine.cgPath
            }
            
            if !downs.isEmpty {
                let downLine = UIBezierPath()
                for point in downs {
                    downLine.move(to: point.lowPoint)
                    downLine.addLine(to: point.highPoint)
                }
                downLayer.path = downLine.cgPath
            }
        }
    }
}
