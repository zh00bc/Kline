//
//  LongPressLabel.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit
import SnapKit

enum LongPressPriceViewType {
    case left
    case right
}

class LongPressPriceView: UIView {
    let type: LongPressPriceViewType

    lazy var baseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.red.cgColor
        layer.lineWidth = 1.0
        return layer
    }()
    
    init(type: LongPressPriceViewType) {
        self.type = type
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.addSublayer(shapeLayer)
        addSubview(baseLabel)
        baseLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.top.equalTo(self).offset(5)
//            $0.width.equalTo(33)
            $0.height.equalTo(12)
            switch type {
            case .right:
                $0.left.equalTo(self).offset(3.25)
                $0.right.equalTo(self).offset(-9.2)
            case .left:
                $0.left.equalTo(self).offset(9.2)
                $0.right.equalTo(self).offset(-3.25)
            }
        }
    }
    
    var text: String? {
        didSet {
            baseLabel.text = text
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = layer.bounds
        
        let path = UIBezierPath()
        switch type {
        case .right:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: bounds.width - 9.2, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height*0.5))
            path.addLine(to: CGPoint(x: bounds.width - 9.2, y: bounds.height))
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
        case .left:
            path.move(to: CGPoint(x: 0, y: bounds.height * 0.5))
            path.addLine(to: CGPoint(x: 9.2, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: 9.2, y: bounds.height))
        }
        path.close()
        shapeLayer.path = path.cgPath
    }
}
