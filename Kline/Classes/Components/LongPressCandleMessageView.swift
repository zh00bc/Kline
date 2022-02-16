//
//  LongPressCandleMessageView.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

class LongPressCandleMessageView: UIView {
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var amountPrecision: Int = 2
    var pricePrecision: Int = 8
    var period: PeriodType = .min15
    
    var dataSource: [(String, String, UIColor)] = []
    
    var priceData: CandleLinePriceData? {
        didSet {
            if let d = priceData {
                let textColor = ColorManager.shared.klinePrimaryTextColor
                let time = (NSLocalizedString("kline.date", comment: ""), "\(KlineDateCommon.string(timestamp: d.time, period: period))", textColor)
                let open = (NSLocalizedString("kline.open", comment: ""), "\(KLineNumberFormatter.format(d.openPrice, precision: pricePrecision))", textColor)
                let high = (NSLocalizedString("kline.high", comment: ""), "\(KLineNumberFormatter.format(d.highPrice, precision: pricePrecision))", textColor)
                let low = (NSLocalizedString("kline.low", comment: ""), "\(KLineNumberFormatter.format(d.lowPrice, precision: pricePrecision))", textColor)
                let close = (NSLocalizedString("kline.close", comment: ""), "\(KLineNumberFormatter.format(d.closePrice, precision: pricePrecision))", textColor)
                let change = (NSLocalizedString("kline.change", comment: ""), "\(KLineNumberFormatter.format(d.change, precision: pricePrecision, numberStyle: .decimal, positivePrefix: true))", d.priceUp ? ColorManager.shared.kColorShadeButtonGreenEnd : ColorManager.shared.kColorShadeButtonRedEnd)
                let changeRate = (NSLocalizedString("kline.change%", comment: ""), "\(KLineNumberFormatter.format(d.changeRate, precision: 2, positivePrefix: true))%", d.priceUp ? ColorManager.shared.kColorShadeButtonGreenEnd : ColorManager.shared.kColorShadeButtonRedEnd)
                let executed = (NSLocalizedString("kline.volume", comment: ""), "\(KLineNumberFormatter.format(d.volume, precision: amountPrecision))", textColor)
                dataSource = [time, open, high, low, close, change, changeRate, executed]
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
        layer.borderColor = ColorManager.shared.kColorSecondaryText.cgColor
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.95)//ColorManager.shared.klineIndexBackgroundGradientColorStart
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 17.0
        tableView.register(LongPressCandleMessageCell.self, forCellReuseIdentifier: "LongPressCandleMessageCell")
        tableView.dataSource = self
        addSubview(tableView)
        self.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(140)
        }
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(2)
        }
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
