//
//  SlitherDataCommon.swift
//  kline
//
//  Created by zhang j on 2019/6/19.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

class KLineData {
    
}

class LineData: KLineData {
    var x: Double = 0
    var y: Double = 0
    /// 分时线如果是昨天的数据，就显示灰色
    var bColorDeep: Bool = false
    var nDataIndex: Int = 0
    var isNullData: Bool = false
}

class ColumnarData: KLineData {
    var lowPoint: CGPoint = .zero
    var highPoint: CGPoint = .zero
    var rgbColor: UIColor = .clear
    var isNullData: Bool = false
    var priceUp: Bool = false
}

class CandleData: KLineData {
    var lowPoint: CGPoint = .zero
    var highPoint: CGPoint = .zero
    var openPoint: CGPoint = .zero
    var closePoint: CGPoint = .zero
    
    var nDataIndex: Int = 0

    var lowPrice: NSNumber = 0
    var highPrice: NSNumber = 0
    
    func getClosePoint() -> LineData {
        let lineData = LineData()
        lineData.x = Double(closePoint.x)
        lineData.y = Double(closePoint.y)
        lineData.nDataIndex = nDataIndex
        return lineData
    }
}
