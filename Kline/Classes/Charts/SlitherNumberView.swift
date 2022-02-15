//
//  ZHSlitherNumberView.swift
//  kline
//
//  Created by zhangj on 2019/5/31.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

enum NumberViewType {
    case main
    case volume
    case assistant
}

enum DataType {
    case assistIndex
    case master
    case volume
}

class SlitherNumberView: UIView {
    /// 显示指标数据
    private var messageView: SlitherMessageView!
    private var numbers: [BaseLabel] = []
    private var lines: [UIView] = []
    /// LandScape
    var bFullView: Bool = false
    
    let type: NumberViewType

    var messages: [KLineTipModel] = [] {
        didSet {
            messageView.update(messages: messages)
        }
    }
    
    /// 数线条数
    let xLineNumber: Int
    /// 横线条数
    let yLineNumber: Int
    
    let lineHeight: CGFloat = 0.5

    var xSpacing: CGFloat {
        return bounds.width / CGFloat( xLineNumber + 1 )
    }
    
    var ySpacing: CGFloat {
        return (bounds.height - Constants.mainChartTopOffset) / CGFloat( yLineNumber - 1)
    }
    
    var style: ChartStyle?
    
    deinit {
        debugPrint("SlitherNumberView deinit")
    }
    
    init(type: NumberViewType, style: ChartStyle? = nil) {
        self.type = type
        self.xLineNumber = 4
        self.style = style
        
        switch type {
        case .main:
            yLineNumber = 5
        case .volume:
            yLineNumber = 2
        case .assistant:
            yLineNumber = 3
        }
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        messageView = SlitherMessageView()
        addSubview(messageView)
        for _ in stride(from: 0, to: 5, by: 1) {
            let textLabel = BaseLabel()
            textLabel.font = UIFont.systemFont(ofSize: 10)
            textLabel.font = CustomFonts.DIN.medium.font(ofSize: 10)
            textLabel.textColor = ColorManager.shared.klineCnyRateColor
            addSubview(textLabel)
            numbers.append(textLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addNumbers()
        addLine()
        setupGradient()
        messageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: Constants.messageViewHeight)
        bringSubviewToFront(messageView)
    }
    
    /// max(a3) min(a4) chartType(a5) pricePrecision(a6) amountPrecision(a7)
    func changeNumber(max: NSNumber, min: NSNumber, chartType: ChartType, pricePrecision: Int, amountPrecision: Int) {
        switch type {
        case .volume:
            if max.doubleValue > 0 {
                numbers[0].text = KLineNumberFormatter.format(volume: max, amountPrecision: amountPrecision)
            } else {
                numbers[0].text = ""
            }
        case .main:
            if max.compare(min) != .orderedAscending {
                let step = ( max.doubleValue - min.doubleValue ) / Double( yLineNumber - 1 )
                numbers[0].text = KLineNumberFormatter.format(max, precision: pricePrecision)
                numbers[1].text = KLineNumberFormatter.format(max.doubleValue - step, precision: pricePrecision)
                numbers[2].text = KLineNumberFormatter.format(max.doubleValue - 2 * step, precision: pricePrecision)
                numbers[3].text = KLineNumberFormatter.format(max.doubleValue - 3 * step, precision: pricePrecision)
                numbers[4].text = KLineNumberFormatter.format(min, precision: pricePrecision)
            } else {
                numbers[0].text = ""
                numbers[1].text = ""
                numbers[2].text = ""
                numbers[3].text = ""
                numbers[4].text = ""
            }
            
        case .assistant:
            if max.compare(min) != .orderedAscending {
                let step = ( max.doubleValue - min.doubleValue ) / 2.0
                numbers[0].text = KLineNumberFormatter.format(max, precision: 2, roundingMode: .down)
                numbers[1].text = KLineNumberFormatter.format(min.doubleValue + step, precision: 2, roundingMode: .down)
                numbers[2].text = KLineNumberFormatter.format(min, precision: 2, roundingMode: .down)
            } else {
                numbers[0].text = ""
                numbers[1].text = ""
                numbers[2].text = ""
            }
        }
    }
    
    func addNumbers() {
        switch type {
        case .main:
            numbers[0].snp.remakeConstraints {
                $0.right.equalTo(self).offset(-5)
                $0.top.equalTo(self).offset(Constants.mainChartTopOffset)
            }
            numbers[1].snp.remakeConstraints {
                $0.right.equalTo(numbers[0])
                $0.bottom.equalTo(self.snp.top).offset(Constants.mainChartTopOffset + ySpacing)
            }
            numbers[2].snp.remakeConstraints {
                $0.right.equalTo(numbers[0])
                $0.bottom.equalTo(self.snp.top).offset(Constants.mainChartTopOffset + 2 * ySpacing)
            }
            numbers[3].snp.remakeConstraints {
                $0.right.equalTo(numbers[0])
                $0.bottom.equalTo(self.snp.top).offset(Constants.mainChartTopOffset + 3 * ySpacing)
            }
            numbers[4].snp.remakeConstraints {
                $0.right.equalTo(numbers[0])
                $0.bottom.equalTo(self)
            }
        case .volume:
            numbers[0].snp.remakeConstraints {
                $0.right.equalTo(self).offset(-5)
                $0.top.equalTo(self)
            }
            numbers[1].snp.remakeConstraints {
                $0.right.equalTo(numbers[0])
                $0.bottom.equalTo(self)
            }
        case .assistant:
            numbers[0].snp.remakeConstraints {
                $0.right.equalTo(self).offset(-5)
                $0.top.equalTo(self)
            }
            numbers[1].snp.remakeConstraints {
                $0.right.equalTo(numbers[0])
                $0.centerY.equalTo(self)
            }
            numbers[2].snp.remakeConstraints {
                $0.right.equalTo(numbers[0])
                $0.bottom.equalTo(self)
            }
            
            
        }
    }
    
    func addLine() {
        
        subviews.filter({ $0.tag == 42 }).forEach({ $0.removeFromSuperview() })
        
        /// 竖线
        var index = 1
        while index <= xLineNumber {
            let verLine = UIView()
            verLine.tag = 42
            verLine.backgroundColor = style?.numberViewLineColor ?? ColorManager.shared.slitherNumberLineColor
            addSubview(verLine)
            lines.append(verLine)
            
            verLine.frame = CGRect(x: xSpacing * CGFloat(index) - lineHeight * 0.5, y: 0, width: lineHeight, height: bounds.height)
            index += 1
        }
        
        /// 横线
        switch type {
        case .main:
            addLine(frame: CGRect(x: 0.0, y: Constants.mainChartTopOffset, width: bounds.width, height: lineHeight))
            addLine(frame: CGRect(x: 0.0, y: Constants.mainChartTopOffset + ySpacing, width: bounds.width, height: lineHeight))
            addLine(frame: CGRect(x: 0.0, y: Constants.mainChartTopOffset + 2 * ySpacing, width: bounds.width, height: lineHeight))
            addLine(frame: CGRect(x: 0.0, y: Constants.mainChartTopOffset + 3 * ySpacing, width: bounds.width, height: lineHeight))
            addLine(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: lineHeight))
        case .volume:
            addLine(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: lineHeight))
            addLine(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: lineHeight))
        case .assistant:
            addLine(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: lineHeight))
            addLine(frame: CGRect(x: 0.0, y: numbers[1].frame.maxY, width: bounds.width, height: lineHeight))
            addLine(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: lineHeight))
        }
    }
    
    func addLine(frame: CGRect) {
        let lineView = UIView(frame: frame)
        lineView.tag = 42
        lineView.backgroundColor = style?.numberViewLineColor ?? ColorManager.shared.slitherNumberLineColor
        addSubview(lineView)
    }
    
    func setupGradient() {
        switch type {
        case .main:
            gradientLayer.colors = style?.mainChartGradientColors ?? [ColorManager.shared.klineMainBackgroundGradientColor1,
                                    ColorManager.shared.klineMainBackgroundGradientColor2]
        case .volume:
            gradientLayer.colors = style?.volumeChartGradientColors ?? [ColorManager.shared.klineVolumeBackgroundGradientColor1,
                                    ColorManager.shared.klineVolumeBackgroundGradientColor2]
        case .assistant:
            gradientLayer.colors = style?.assistantChartGradientColors ?? [ColorManager.shared.klineVolumeBackgroundGradientColor1,
                                    ColorManager.shared.klineVolumeBackgroundGradientColor2]
        }
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
}
