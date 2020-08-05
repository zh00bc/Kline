//
//  LongPressCell.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

class LongPressCandleMessageCell: UITableViewCell {
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        nameLabel.font = CustomFonts.DIN.medium.font(ofSize: 10)
        valueLabel.font = CustomFonts.DIN.medium.font(ofSize: 10)
        nameLabel.textColor = ColorManager.shared.klinePrimaryTextColor
        valueLabel.textColor = ColorManager.shared.klinePrimaryTextColor
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
        }
        valueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
        }
    }
}
