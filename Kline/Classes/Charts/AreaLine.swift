//
//  AreaLine.swift
//  kline
//
//  Created by zhangj on 2020/7/21.
//  Copyright © 2020 zhangj. All rights reserved.
//

import Foundation
import UIKit

class AreaLine: KLine {
    let gradientMask = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    let todayShapeLayer = CAShapeLayer()
    let yesterdayShapeLayer = CAShapeLayer()
    
    override func setup() {
        masksToBounds = true

        addSublayer(gradientLayer)
        gradientLayer.mask = gradientMask
        let colors = [ColorManager.shared.klineMinuteDropdownGradientColor1.cgColor,
                      ColorManager.shared.klineMinuteDropdownGradientColor2.cgColor,
                      ColorManager.shared.klineMinuteDropdownGradientColor34.cgColor,
                      ColorManager.shared.klineMinuteDropdownGradientColor34.cgColor]
        gradientLayer.colors = colors
        
        yesterdayShapeLayer.fillColor = UIColor.clear.cgColor
        yesterdayShapeLayer.lineWidth = 1.0
        yesterdayShapeLayer.strokeColor = ColorManager.shared.klinePreDayMinuteColor.cgColor
        yesterdayShapeLayer.shadowColor = ColorManager.shared.klineMinuteShadowColor.cgColor
        yesterdayShapeLayer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        yesterdayShapeLayer.shadowRadius = 8.0

        addSublayer(yesterdayShapeLayer)
        todayShapeLayer.fillColor = UIColor.clear.cgColor
        todayShapeLayer.lineWidth = 1.0
        todayShapeLayer.strokeColor = ColorManager.shared.klineMinuteLineColor.cgColor
        todayShapeLayer.shadowColor = ColorManager.shared.klineMinuteShadowColor.cgColor
        todayShapeLayer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        todayShapeLayer.shadowRadius = 8.0
        addSublayer(todayShapeLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        gradientLayer.frame = bounds
        gradientMask.frame = bounds
        todayShapeLayer.frame = bounds
        yesterdayShapeLayer.frame = bounds
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        if let lineDatas = points as? [LineData], lineDatas.count > 0 {
            let todayPath = UIBezierPath()
            
            var prevPrev, prev, next: LineData
            
            for (index, point) in lineDatas.enumerated() {
                prevPrev = lineDatas[max(index - 2, 0)]
                prev = lineDatas[max(index - 1, 0)]
                next = lineDatas[min(index + 1, lineDatas.count - 1)]
                
                if index == 0 {
                    todayPath.move(to: CGPoint(x: point.x, y: point.y))
                } else {
                    drawBessel(x0: prevPrev.x, y0: prevPrev.y, x1: prev.x, y1: prev.y, x2: point.x, y2: point.y, x3: next.x, y3: next.y, path: todayPath)
                }
            }
            
            let shadowPath = todayPath.copy() as! UIBezierPath
            shadowPath.addLine(to: CGPoint(x: lineDatas.last!.x, y: Double(bounds.height)))
            shadowPath.addLine(to: CGPoint(x: 0.0, y: bounds.height))
            shadowPath.close()
            todayShapeLayer.path = todayPath.cgPath
            gradientMask.path = shadowPath.cgPath
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    // x0(a3) y0(a4) x1(a5) y1(a6) x2(a7) y2(a8) x3(a9) y3(a10) path(a11)
    func drawBessel(x0: Double, y0: Double, x1: Double, y1: Double, x2: Double, y2: Double, x3: Double, y3: Double, path: UIBezierPath) {
        let v13 = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2))
        let v14 = sqrt(pow((x3 - x2), 2) + pow((y3 - y2), 2))
        let v15 = sqrt(pow((x1 - x0), 2) + pow((y1 - y0), 2)) + v13
        
        let cp1 = CGPoint(x: (x2 - x0) * v13 / v15 * 0.6 * 0.5 + x1,
                          y: (y2 - y0) * v13 / v15 * 0.6 * 0.5 + y1)
        let cp2 = CGPoint(x: (x1 - x3) * v13 / (v13 + v14) * 0.6 * 0.5 + x2,
                          y: (y1 - y3) * v13 / (v13 + v14) * 0.6 * 0.5 + y2)
        path.addCurve(to: CGPoint(x: x2, y: y2), controlPoint1: cp1, controlPoint2: cp2)
    }
    
//    override func draw(in ctx: CGContext) {
//        if points.count >= 2 {
//            ctx.saveGState()
//            ctx.setShouldAntialias(true)
//
//            drawCubicLine(inContext: ctx)
//
//            ctx.addLine(to: CGPoint(x: CGFloat((points.last as! LineData).x), y: bounds.height))
//            ctx.addLine(to: CGPoint(x: 0, y: bounds.height))
//            ctx.clip()
//
//
//            let colors = [ColorManager.shared.klineMinuteDropdownGradientColor1.cgColor,
//                          ColorManager.shared.klineMinuteDropdownGradientColor2.cgColor,
//                          ColorManager.shared.klineMinuteDropdownGradientColor34.cgColor,
//                          ColorManager.shared.klineMinuteDropdownGradientColor34.cgColor]
//            let colorSpace = CGColorSpaceCreateDeviceRGB()
//            let colorLocations: [CGFloat] = [0.0, 0.3, 0.6, 1.0]
//            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) {
//                ctx.drawLinearGradient(gradient,
//                                       start: CGPoint(x: bounds.width*0.5, y: 0),
//                                       end: CGPoint(x: bounds.width*0.5, y: bounds.height),
//                                       options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
//            }
//
//            ctx.restoreGState()
//
//            ctx.saveGState()
//            ctx.setShouldAntialias(true)
//            ctx.setStrokeColor(ColorManager.shared.klineMinuteLineColor.cgColor)
//            ctx.setLineWidth(1.0)
//
//            drawCubicLine(inContext: ctx)
//
//            ctx.setShadow(offset: CGSize(width: 3, height: 3), blur: 5, color: UIColor.black.cgColor)
//
//            ctx.setLineCap(.round)
//            ctx.strokePath()
//
//            ctx.restoreGState()
//        }
//    }
    
//    func drawCubicLine(in path: UIBezierPath) {
//        if let lineDatas = points as? [LineData] {
//            let intensity = 0.07
//            var prevDx: Double = 0.0
//            var prevDy: Double = 0.0
//            var curDx: Double = 0.0
//            var curDy: Double = 0.0
//
//            let firstIndex = 1
//            let lastIndex = lineDatas.count - 1
//
//            var prevPrev: LineData! = nil
//            var prev: LineData! = lineDatas[max(firstIndex - 2, 0)]
//            var cur: LineData! = lineDatas[max(firstIndex - 1, 0)]
//            var next: LineData! = cur
//            var nextIndex: Int = -1
//
//            if cur == nil { return }
//
//            path.move(to: CGPoint(x: cur.x, y: cur.y))
//
//            for index in stride(from: firstIndex, through: lastIndex, by: 1) {
//                prevPrev = prev
//                prev = cur
//                cur = nextIndex == index ? next : lineDatas[index]
//
//                nextIndex = index + 1 < lineDatas.count ? index + 1 : index
//                next = lineDatas[nextIndex]
//
//                if next == nil { break }
//
//                prevDx = (cur.x - prevPrev.x) * intensity
//                prevDy = (cur.y - prevPrev.y) * intensity
//                curDx = (next.x - prev.x) * intensity
//                curDy = (next.y - prev.y) * intensity
//
//                path.addCurve(
//                    to: CGPoint(
//                        x: cur.x,
//                        y: cur.y),
//                    controlPoint1: CGPoint(
//                        x: prev.x + prevDx,
//                        y: prev.y + prevDy),
//                    controlPoint2: CGPoint(
//                        x: cur.x - curDx,
//                        y: cur.y - curDy))
//            }
//        }
//    }
    
//    func drawCubicLine(inContext context: CGContext) {
//        if let lineDatas = points as? [LineData] {
//            let intensity = 0.07
//            var prevDx: Double = 0.0
//            var prevDy: Double = 0.0
//            var curDx: Double = 0.0
//            var curDy: Double = 0.0
//
//            let firstIndex = 1
//            let lastIndex = lineDatas.count - 1
//
//            var prevPrev: LineData! = nil
//            var prev: LineData! = lineDatas[max(firstIndex - 2, 0)]
//            var cur: LineData! = lineDatas[max(firstIndex - 1, 0)]
//            var next: LineData! = cur
//            var nextIndex: Int = -1
//
//            if cur == nil { return }
//
//            context.move(to: CGPoint(x: cur.x, y: cur.y))
//
//            for index in stride(from: firstIndex, through: lastIndex, by: 1) {
//                prevPrev = prev
//                prev = cur
//                cur = nextIndex == index ? next : lineDatas[index]
//
//                nextIndex = index + 1 < lineDatas.count ? index + 1 : index
//                next = lineDatas[nextIndex]
//
//                if next == nil { break }
//
//                prevDx = (cur.x - prevPrev.x) * intensity
//                prevDy = (cur.y - prevPrev.y) * intensity
//                curDx = (next.x - prev.x) * intensity
//                curDy = (next.y - prev.y) * intensity
//
//                context.addCurve(
//                    to: CGPoint(
//                        x: cur.x,
//                        y: cur.y),
//                    control1: CGPoint(
//                        x: prev.x + prevDx,
//                        y: prev.y + prevDy),
//                    control2: CGPoint(
//                        x: cur.x - curDx,
//                        y: cur.y - curDy))
//            }
//        }
//    }
}


