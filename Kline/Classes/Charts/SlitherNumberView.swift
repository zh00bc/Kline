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
    
    deinit {
        debugPrint("SlitherNumberView deinit")
    }
    
    init(type: NumberViewType) {
        self.type = type
        self.xLineNumber = 4
        
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
            if min.doubleValue > 0 {
                numbers[1].text = KLineNumberFormatter.format(volume: min, amountPrecision: amountPrecision)
            } else {
                numbers[1].text = ""
            }
        case .main:
            let step = ( max.doubleValue - min.doubleValue ) / Double( yLineNumber - 1 )
            numbers[0].text = KLineNumberFormatter.format(max, precision: pricePrecision)
            numbers[1].text = KLineNumberFormatter.format(max.doubleValue - step, precision: pricePrecision)
            numbers[2].text = KLineNumberFormatter.format(max.doubleValue - 2 * step, precision: pricePrecision)
            numbers[3].text = KLineNumberFormatter.format(max.doubleValue - 3 * step, precision: pricePrecision)
            numbers[4].text = KLineNumberFormatter.format(min, precision: pricePrecision)
        case .assistant:
            let step = ( max.doubleValue - min.doubleValue ) / 2.0
            numbers[0].text = String(format: "%.2f", max)
            numbers[1].text = String(format: "%.2f", min.doubleValue + step)
            numbers[2].text = String(format: "%.2f", min)
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
            verLine.backgroundColor = ColorManager.shared.slitherNumberLineColor
            addSubview(verLine)
            lines.append(verLine)
            verLine.snp.makeConstraints {
                $0.centerX.equalTo(self.snp.left).offset(xSpacing * CGFloat(index))
                $0.width.equalTo(lineHeight)
                $0.top.bottom.equalTo(self)
            }
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
        lineView.backgroundColor = ColorManager.shared.slitherNumberLineColor
        addSubview(lineView)
    }
    
    func setupGradient() {
        switch type {
        case .main:
            gradientLayer.colors = [ColorManager.shared.klineMainBackgroundGradientColor1,
                                    ColorManager.shared.klineMainBackgroundGradientColor2,
                                    ColorManager.shared.klineMainBackgroundGradientColor3]
        case .volume:
            gradientLayer.colors = [ColorManager.shared.klineVolumeBackgroundGradientColor1,
                                    ColorManager.shared.klineVolumeBackgroundGradientColor2]
        case .assistant:
            gradientLayer.colors = [ColorManager.shared.klineVolumeBackgroundGradientColor1,
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
