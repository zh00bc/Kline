//
//  LongPressLabel.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

class LongPressLabel: UILabel {
    
    let showLabel: UILabel
    
    var bInLeft: Bool = false
    
    override init(frame: CGRect) {
        
        showLabel = UILabel()
        showLabel.textColor = ColorManager.shared.klineCrossCursorPriceTextColor
        showLabel.font = CustomFonts.DIN.medium.font(ofSize: 9)
        
        super.init(frame: frame)
        
        addSubview(showLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        context.setLineWidth(1.0)
        context.setStrokeColor(ColorManager.shared.klineCrossCursorPriceBorderColor.cgColor)
        context.setFillColor(ColorManager.shared.klineIndexBackgroundGradientColorStart.withAlphaComponent(0.9).cgColor)
        
        let radius: CGFloat = 4
        if bInLeft {
            context.move(to: CGPoint(x: bounds.width, y: showLabel.center.y))
            context.addLine(to: CGPoint(x: bounds.width - 9.25, y: 0))
            context.addLine(to: CGPoint(x: radius, y: 0))
            context.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: .pi * 1.5, endAngle: .pi, clockwise: true)
            context.addLine(to: CGPoint(x: 0, y: bounds.height - radius))
            context.addArc(center: CGPoint(x: radius, y: bounds.height - radius), radius: radius, startAngle: .pi, endAngle: .pi * 0.5, clockwise: true)
            context.addLine(to: CGPoint(x: bounds.width - 9.25, y: bounds.height))
            context.closePath()
        } else {
            context.move(to: CGPoint(x: 0, y: showLabel.center.y))
            context.addLine(to: CGPoint(x: 9.25, y: 0))
            context.addLine(to: CGPoint(x: bounds.width - radius, y: 0))
            context.addArc(center: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: .pi * 1.5, endAngle: .pi * 2, clockwise: false)
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height - radius))
            context.addArc(center: CGPoint(x: bounds.width - radius, y: bounds.height - radius), radius: radius, startAngle: .pi * 2, endAngle: .pi * 0.5, clockwise: false)
            context.addLine(to: CGPoint(x: 9.25, y: bounds.height))
            context.closePath()
        }
        context.drawPath(using: .fillStroke)
        
        bringSubviewToFront(showLabel)
    }
    
    func change(text: String) {
        showLabel.text = text
        
        if bInLeft {
            showLabel.snp.remakeConstraints {
                $0.centerY.equalTo(self)
                $0.left.equalTo(self).offset(3.25)
                $0.right.equalTo(self).offset(-9.25)
                $0.top.equalTo(self).offset(5)
            }
        } else {
            showLabel.snp.remakeConstraints {
                $0.centerY.equalTo(self)
                $0.right.equalTo(self).offset(-3.25)
                $0.left.equalTo(self).offset(9.25)
                $0.top.equalTo(self).offset(5)
            }
        }
        
        showLabel.sizeToFit()
    }
}
