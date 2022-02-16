//
//  ChartViewDataSource.swift
//  kline
//
//  Created by zhang j on 2019/6/18.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

protocol ChartViewDataSource: AnyObject {
    var currentMaxWidth: CGFloat { get }
    var period: PeriodType { get }
    
    func numberOfLines(in chartView: ChartView) -> Int
    func kLine(for chartView: ChartView, atIndex: Int) -> KLine
    
    func updatePoints(of chartView: ChartView, kLine: KLine, atIndex: Int)
}

