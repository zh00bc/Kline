//
//  SlitherPriceView.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit
import Foundation

class SlitherMessageView: UIView {
    var attributes: [String: Any]!
    
    var textLayers: [CATextLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func update(messages: [KLineTipModel]) {
        for (index, textLayer) in textLayers.enumerated() {
            if index < messages.count {
                textLayer.isHidden = false
            } else {
                textLayer.isHidden = true
            }
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for (index, message) in messages.enumerated() {
            let textLayer = textLayers[index]
            textLayer.string = message.lineTip
            textLayer.foregroundColor = message.color.cgColor
            
            let width = ceil(message.lineTip.width(using: UIFont.systemFont(ofSize: 9)))
                        
            if index > 0 {
                textLayer.frame = CGRect(x: textLayers[index - 1].frame.maxX + 14.5, y: 0, width: width, height: 12.0)
            } else {
                textLayer.frame = CGRect(x: 5.0, y: 0, width: width, height: 12.0)
            }
        }
        
        CATransaction.commit()
    }
    
    func setup() {
        for _ in 1...6 {
            let textLayer = CATextLayer()
            textLayer.font = UIFont.systemFont(ofSize: 9)
            textLayer.fontSize = 9
            textLayer.alignmentMode = .justified
            textLayer.contentsScale = UIScreen.main.scale
            layer.addSublayer(textLayer)
            textLayers.append(textLayer)
        }
    }
}
