//
//  LongPressCandleMessageView.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

class DynamicHeightTableView: UITableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

class LongPressCandleMessageView: UIView {
    let tableView = DynamicHeightTableView(frame: CGRect.zero, style: .plain)
    var amountPrecision: Int = 2
    var pricePrecision: Int = 8
    var period: PeriodType = .min15
    
    var dataSource: [(String, String, UIColor)] = []
    
    var priceData: CandleLinePriceData? {
        didSet {
            if let d = priceData {
                let textColor = ColorManager.shared.klinePrimaryTextColor
                
                let time = (LanguageManager.shared.localize(string: "kline.date"), "\(KlineDateCommon.string(timestamp: d.time, period: .day))", textColor)
                let open = (LanguageManager.shared.localize(string: "kline.open"), "\(KLineNumberFormatter.format(d.openPrice, precision: pricePrecision))", textColor)
                let changeRate = (LanguageManager.shared.localize(string: "kline.change%"), "\(KLineNumberFormatter.format(d.changeRate, precision: 2, positivePrefix: true))%", d.changeRate.doubleValue >= 0 ? ColorManager.shared.kColorShadeButtonGreenEnd : ColorManager.shared.kColorShadeButtonRedEnd)
                
                if d.isLast {
                    let close = (LanguageManager.shared.localize(string: "kline.current"), "\(KLineNumberFormatter.format(d.volume, precision: pricePrecision))", textColor)
                    dataSource = [time, open, close, changeRate]
                } else {
                    let close = (LanguageManager.shared.localize(string: "kline.close"), "\(KLineNumberFormatter.format(d.volume, precision: pricePrecision))", textColor)
                    dataSource = [time, open, close, changeRate]
                }
            } else {
                dataSource = []
            }
            tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 5
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        layer.borderColor = ColorManager.shared.main.cgColor
        backgroundColor = .white
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 20.0
        tableView.register(LongPressCandleMessageCell.self, forCellReuseIdentifier: "LongPressCandleMessageCell")
        tableView.dataSource = self
        addSubview(tableView)
        self.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(74)
        }
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor(red: 0.933, green: 0.6, blue: 0.133, alpha: 0.12).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 9.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.cornerRadius = 6
    }
}

extension LongPressCandleMessageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LongPressCandleMessageCell", for: indexPath) as! LongPressCandleMessageCell
        let data = dataSource[indexPath.row]
        cell.nameLabel.text = data.0
        cell.valueLabel.text = data.1
        cell.valueLabel.textColor = data.2
        return cell
    }
}
