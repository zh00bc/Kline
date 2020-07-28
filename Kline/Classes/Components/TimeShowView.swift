//
//  TimeShowView.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit
import SnapKit

class TimeShowView: UIView {
    
    var timeLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func update(times: [String]) {
        for (index, timeLabel) in timeLabels.enumerated() {
            if index < times.count {
                timeLabel.isHidden = false
                timeLabel.text = times[index]
            } else {
                timeLabel.isHidden = true
            }
        }
    }
    
    func setup() {
        isUserInteractionEnabled = false
        layer.masksToBounds = true
        
        for index in 0...5 {
            let timeLabel = BaseLabel()
            timeLabel.font = CustomFonts.DIN.medium.font(ofSize: 10)
            timeLabel.textColor = ColorManager.shared.kColorSecondaryText
            timeLabel.textAlignment = .center
            timeLabels.append(timeLabel)
            addSubview(timeLabel)
            
            timeLabel.snp.makeConstraints {
                $0.top.bottom.equalTo(self)
                if index == 0 {
                    $0.centerX.equalTo(self.snp.left)
                } else if index == 6 {
                    $0.centerX.equalTo(self.snp.right)
                } else {
                    $0.centerX.equalTo(self.snp.centerX).multipliedBy(0.4 * Double(index))
                }
            }
        }
    }
}
