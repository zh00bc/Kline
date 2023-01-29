//
//  LongPressShowView.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

enum PressedType {
    case none
    case long
    case short
}

class KLineVerticalView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
}

class LongPressShowView: UIView {
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)

    var pressedType: PressedType = .short
    
    var chartStyle: ChartStyle?

    lazy var messageView: LongPressCandleMessageView = {
        let messageView = LongPressCandleMessageView()
        return messageView
    }()
    
    lazy var hLine: UIView = {
        let horLine = UIView()
        horLine.backgroundColor = ColorManager.shared.klinePrimaryTextColor
        return horLine
    }()
    
    lazy var vLine: KLineVerticalView = {
        let verLine = KLineVerticalView()
        verLine.gradientLayer.colors = [
            ColorManager.shared.klineCrossCursorGradientColor1.cgColor,
            ColorManager.shared.klineCrossCursorGradientColor24.cgColor,
            ColorManager.shared.klineCrossCursorGradientColor3.cgColor,
            ColorManager.shared.klineCrossCursorGradientColor24.cgColor,
            ColorManager.shared.klineCrossCursorGradientColor5.cgColor]
        verLine.gradientLayer.startPoint = CGPoint.zero
        verLine.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return verLine
    }()
    
    lazy var tipLabel: LongPressLabel = {
        let label = LongPressLabel()
        return label
    }()
    
    lazy var roundPriceView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.backgroundColor = .white.withAlphaComponent(0.60)
        
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 3.0
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(6)
        }
        
        let redView = UIView()
        redView.backgroundColor = ColorManager.shared.main
        redView.layer.cornerRadius = 2
        view.addSubview(redView)
        redView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(4)
        }
        return view
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: Constants.timeViewHeight))
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = ColorManager.shared.klinePrimaryTextColor
//        label.textAlignment = .center
        label.layer.borderColor = UIColor.clear.cgColor//ColorManager.shared.kColorSecondaryText.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3.0
        label.layer.masksToBounds = true
        
        label.backgroundColor = ColorManager.shared.klineIndexBackgroundGradientColorStart
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        isUserInteractionEnabled = false
        
        addSubview(vLine)
        addSubview(hLine)
        addSubview(roundPriceView)
        addSubview(tipLabel)
        addSubview(timerLabel)
        addSubview(messageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(time: String) {
        timerLabel.text = " \(time) "
        timerLabel.sizeToFit()
        timerLabel.frame = CGRect(origin: timerLabel.frame.origin, size: CGSize(width: timerLabel.bounds.width, height: 20))
    }

    func touchShow(point: CGPoint, period: PeriodType, price: NSNumber, timeCenterY: CGFloat, lineWidth: CGFloat, kLineModel: CandleLinePriceData, pricePrecision: Int, amountPrecision: Int) {
        pressShow(point: point, period: period, price: price, timeCenterY: timeCenterY, lineWidth: lineWidth, kLineModel: kLineModel, pressedType: .short, pricePrecision: pricePrecision, amountPrecision: amountPrecision)
    }
    
    func longPressShow(point: CGPoint, period: PeriodType, timeCenterY: CGFloat, lineWidth: CGFloat, kLineModel: CandleLinePriceData, pricePrecision: Int, amountPrecision: Int) {
        if pressedType != .long {
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
        
        if period != .timeline {
            if kLineModel.time != messageView.priceData?.time {
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            }
        }
        pressShow(point: point, period: period, price: kLineModel.closePrice, timeCenterY: timeCenterY, lineWidth: lineWidth, kLineModel: kLineModel, pressedType: .long, pricePrecision: pricePrecision, amountPrecision: amountPrecision)
    }
    
    func pressShow(point: CGPoint, period: PeriodType, price: NSNumber, timeCenterY: CGFloat, lineWidth: CGFloat, kLineModel: CandleLinePriceData, pressedType: PressedType, pricePrecision: Int, amountPrecision: Int) {
        isHidden = false
        superview?.bringSubviewToFront(self)
        self.pressedType = pressedType
        
        update(time: KlineDateCommon.string(timestamp: kLineModel.time, period: period))
        
        messageView.amountPrecision = amountPrecision
        messageView.pricePrecision = pricePrecision
        messageView.period = period
        
        vLine.snp.remakeConstraints {
            $0.width.equalTo(8)
            if let chartStyle = chartStyle, chartStyle.showTime {
                $0.bottom.equalTo(self).offset(-Constants.timeViewHeight)
            } else {
                $0.bottom.equalTo(self)
            }
            $0.top.equalTo(self).offset(Constants.mainChartTopOffset)
            $0.centerX.equalTo(self.snp.left).offset(point.x)
        }
        
        roundPriceView.snp.remakeConstraints {
            $0.centerX.equalTo(vLine)
            $0.centerY.equalTo(self.snp.top).offset(point.y + Constants.mainChartTopOffset)
            $0.height.width.equalTo(10)
        }
        
        var candleMessageViewHeight: CGFloat = 94
//        if kLineModel.isLast {
//            candleMessageViewHeight = 94
//        }
        
        if point.x <= bounds.width * 0.5 {
            tipLabel.bInLeft = true
            tipLabel.snp.remakeConstraints {
                $0.left.equalTo(self)
                $0.centerY.equalTo(self.snp.top).offset(point.y + Constants.mainChartTopOffset)
            }
            
            hLine.snp.remakeConstraints {
                $0.left.equalTo(tipLabel.snp.right)
                $0.right.equalTo(self)
                $0.height.equalTo(0.5)
                $0.centerY.equalTo(tipLabel)
            }
            
            messageView.snp.remakeConstraints {
                $0.right.equalToSuperview().offset(-5)
                $0.top.equalToSuperview().offset(27)
                $0.width.equalTo(Constants.candleMessageViewWidth)
                $0.height.equalTo(candleMessageViewHeight)
            }
        } else {
            tipLabel.bInLeft = false
            tipLabel.snp.remakeConstraints {
                $0.right.equalTo(self)
                $0.centerY.equalTo(self.snp.top).offset(point.y + Constants.mainChartTopOffset)
            }
            
            hLine.snp.remakeConstraints {
                $0.right.equalTo(tipLabel.snp.left)
                $0.left.equalTo(self)
                $0.height.equalTo(0.5)
                $0.centerY.equalTo(tipLabel)
            }
            
            messageView.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(5)
                $0.top.equalToSuperview().offset(30)
                $0.width.equalTo(Constants.candleMessageViewWidth)
                $0.height.equalTo(candleMessageViewHeight)
            }
        }
        
        tipLabel.change(text: KLineNumberFormatter.format(price, precision: pricePrecision))
        tipLabel.setNeedsDisplay()
        let tw = timerLabel.bounds.width * 0.5
        var twx = point.x
        
        /// 时间超出就靠边显示
        if point.x + tw > bounds.width {
            twx = bounds.width - tw
        }
        if point.x - tw < 0 {
            twx = tw
        }
        timerLabel.center = CGPoint(x: twx, y: timeCenterY)
        
        messageView.priceData = kLineModel
    }
    
    func hide() {
        isHidden = true
        pressedType = .none
    }
}
