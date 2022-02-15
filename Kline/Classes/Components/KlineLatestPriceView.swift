//
//  KlineLatestPriceView.swift
//  kline
//
//  Created by zhangj on 2019/5/27.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

class KLineLatestPriceView: UIView {
    
    lazy var textLayer: CATextLayer = {
        var layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.fontSize = 9.0
        layer.font = UIFont.systemFont(ofSize: 9)//CustomFonts.DIN.medium.font(ofSize: 9)
        layer.foregroundColor = UIColor(hex: "#564CE0").cgColor
        layer.backgroundColor = UIColor.white.cgColor//ColorManager.shared.kColorContentBackground.withAlphaComponent(0.9).cgColor
        return layer
    }()
    
    lazy var nowImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = dashLine(color: UIColor(hex: "#564CE0"))
        return imageView
    }()
    
    lazy var historyImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = dashLine(color: UIColor(hex: "#564CE0"))
        return imageView
    }()
    
    lazy var animationView: CALayer = {
        let baseLayer = CALayer()
        baseLayer.backgroundColor = UIColor.white.cgColor
        baseLayer.cornerRadius = 2
        let duration = 1.5
        
        let animationLayer = CALayer()
        animationLayer.frame = CGRect(x: 0.0, y: 0.0, width: 4, height: 4)
        animationLayer.backgroundColor = UIColor.white.cgColor
        animationLayer.cornerRadius = 2.0
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 3.5
        scaleAnimation.repeatCount = MAXFLOAT
        scaleAnimation.duration = duration
        scaleAnimation.isRemovedOnCompletion = true
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.repeatCount = MAXFLOAT
        opacityAnimation.duration = duration
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        opacityAnimation.isRemovedOnCompletion = true
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        group.animations = [scaleAnimation, opacityAnimation]
        group.repeatCount = MAXFLOAT
        
        animationLayer.add(group, forKey: "BREATHING")
        baseLayer.addSublayer(animationLayer)
        
        baseLayer.isHidden = true
        return baseLayer
    }()
    
    // 文字属性
    var textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9),
                                                         .backgroundColor: ColorManager.shared.kColorContentBackground.withAlphaComponent(0.9),
                                                         .foregroundColor: ColorManager.shared.klineIndexSettingTextColor] {
        didSet {
            if let font = textAttributes[.font] as? UIFont {
                textLayer.font = font
                textLayer.fontSize = font.pointSize
            }
            if let foregroundColor = textAttributes[.foregroundColor] as? UIColor {
                textLayer.foregroundColor = UIColor(hex: "#564CE0").cgColor
            }
            if let backgroundColor = textAttributes[.backgroundColor] as? UIColor {
                textLayer.backgroundColor = UIColor.white.cgColor//backgroundColor.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        nowImageView.isHidden = true
        historyImageView.isHidden = true
        addSubview(nowImageView)
        addSubview(historyImageView)
        layer.addSublayer(animationView)
        layer.addSublayer(textLayer)
    }
    
    func show(price: String, point: CGPoint, showPoint: Bool) -> Bool {
        isHidden = false
        
        textLayer.string = price
        
        let textSize = (price as NSString).boundingRect(with: CGSize(width: 200, height: 20),
                                                        options: .usesFontLeading,
                                                        attributes: textAttributes,
                                                        context: nil)
        let textWidth = ceil(textSize.width)
        let textHeight = ceil(textSize.height)
        
        CATransaction.setDisableActions(true)
        CATransaction.begin()
        
        textLayer.frame = CGRect(x: 0.0, y: 0.0, width: textWidth, height: textHeight)
        
        if point.x + textWidth >= bounds.width {
            textLayer.isHidden = true
            animationView.isHidden = true
        }
        else {
            textLayer.isHidden = false
            let textX = bounds.width - textWidth - 5.0
            let textY = point.y - textHeight * 0.5
            textLayer.frame = CGRect(x: textX, y: textY, width: textWidth, height: textHeight)
            
            animationView.isHidden = !showPoint
        }
        
        animationView.frame = CGRect(x: point.x - 2.0, y: point.y - 2.0, width: 4, height: 4)
        
        if textLayer.isHidden {
            nowImageView.isHidden = true
            historyImageView.isHidden = false
            historyImageView.frame = CGRect(x: 0.0, y: point.y, width: bounds.width, height: 1.0)
        } else {
            nowImageView.isHidden = false
            historyImageView.isHidden = true
            nowImageView.frame = CGRect(x: point.x, y: point.y, width: textLayer.frame.minX - point.x, height: 1.0)
        }
        
        CATransaction.commit()
        
        return textLayer.isHidden
    }
}

extension KLineLatestPriceView {
    func dashLine(color: UIColor) -> UIImage? {
        var lineImage: UIImage?
        UIGraphicsBeginImageContext(CGSize(width: UIScreen.main.bounds.width, height: 1))
        let context = UIGraphicsGetCurrentContext()
        context?.setLineDash(phase: 0, lengths: [3.0, 3.0])
        context?.setStrokeColor(color.cgColor)
        context?.move(to: CGPoint(x: 0.0, y: 0.0))
        context?.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
        context?.strokePath()
        lineImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return lineImage
    }
}
