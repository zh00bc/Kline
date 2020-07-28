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
    
    var dataSource: [(String, String)] = []
    
    var priceData: CandleLinePriceData? {
        didSet {
            if let d = priceData {
                let time = ("Date", "\(KlineDateCommon.string(timestamp: d.time, period: period))")
                let open = ("Open", "\(KLineNumberFormatter.format(d.openPrice, precision: pricePrecision))")
                let high = ("High", "\(KLineNumberFormatter.format(d.highPrice, precision: pricePrecision))")
                let low = ("Low", "\(KLineNumberFormatter.format(d.lowPrice, precision: pricePrecision))")
                let close = ("Close", "\(KLineNumberFormatter.format(d.closePrice, precision: pricePrecision))")
                let change = ("Change", "\(KLineNumberFormatter.format(d.change, precision: pricePrecision))")
                let changeRate = ("Change%", "\(KLineNumberFormatter.format(d.change, precision: 2))")
                let executed = ("Executed", "\(KLineNumberFormatter.format(d.business, precision: amountPrecision))")
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
        backgroundColor = ColorManager.shared.klineIndexBackgroundGradientColorStart
        
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
        return cell
    }
}