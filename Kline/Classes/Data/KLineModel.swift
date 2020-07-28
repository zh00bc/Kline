//
//  CandleLinePriceData.swift
//  kline
//
//  Created by zhangj on 2019/8/10.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation
import UIKit

public class KLineDataChangeModel {
    var lastNum: Int = 0
    var changeAmount: NSDecimalNumber = 0
    var changeLow: NSDecimalNumber = 0
    var changeHigh: NSDecimalNumber = 0
    var changeClose: NSDecimalNumber = 0
    var changeOpen: NSDecimalNumber = 0
    var realData: KLineDataModel = KLineDataModel()
}

public class KLineDataModel {

    public var open: NSDecimalNumber = 0.0
    public var close: NSDecimalNumber = 0.0
    public var low: NSDecimalNumber = 0.0
    public var high: NSDecimalNumber = 0.0
    public var amount: NSDecimalNumber = 0.0
    public var change: NSDecimalNumber = 0.0
    public var changeRate: NSDecimalNumber = 0.0
    public var time: Int = 0
    
    var rsi1: NSNumber = 0.0
    var rsi2: NSNumber = 0.0
    var rsi3: NSNumber = 0.0
    
    var wr1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var wr2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var wr3: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var volMa1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var volMa2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var amountMa1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var amountMa2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var priceMa1: NSNumber = 0.0
    var priceMa2: NSNumber = 0.0
    var priceMa3: NSNumber = 0.0
    var priceMa4: NSNumber = 0.0
    var priceMa5: NSNumber = 0.0
    var priceMa6: NSNumber = 0.0
    
    var bollLb: NSNumber = 0.0
    var bollUb: NSNumber = 0.0
    var bollSummary: NSNumber = 0.0
    
    var kdjJ: NSNumber = 0.0
    var kdjD: NSNumber = 0.0
    var kdjK: NSNumber = 0.0
    
    var macdDea: NSNumber = 0.0
    var macdDif: NSNumber = 0.0
    var macdMacd: NSNumber = 0.0
    
    var priceUp: Bool {
        return open.doubleValue <= close.doubleValue
    }
    
    /// ["KDJ_K": 33, "WR_14": 23]
    var indicators: [String: NSNumber] = [:]
        
    public init() { }
    

    
//    func indicator(for type: Int, index: Int) -> NSNumber {
//        switch type {
//        case 1:
//            if let indicator = indicators["PRICE_MA_\(index)"] {
//                return indicator
//            }
//            return NSNumber(value: Double.greatestFiniteMagnitude)
//        default:
//
//        }
//    }
    
    
    /// - Parameters:
    ///   - type: 指标类型
    ///   - index: 索引
    /// - Returns: 指标值
    func getValue(for type: Int, index: Int) -> NSNumber {
        switch type {
        case 1:
            switch index {
            case 1:
                return priceMa1
            case 2:
                return priceMa2
            case 3:
                return priceMa3
            case 4:
                return priceMa4
            case 5:
                return priceMa5
            case 6:
                return priceMa6
            default:
                return 0
            }
        case 2:
            if index == 2 {
                return amountMa2
            } else {
                return amountMa1
            }
        case 3:
            return bollSummary
        case 4:
            return bollUb
        case 5:
            return bollLb
        case 6:
            return macdDif
        case 7:
            return macdDea
        case 8:
            return macdMacd
        case 9:
            return kdjK
        case 10:
            return kdjD
        case 11:
            return kdjJ
        case 12:
            if index == 1 {
                return rsi2
            } else if index == 2 {
                return rsi3
            } else {
                return rsi1
            }
        case 13:
            if index == 1 {
                return wr2
            } else if index == 2 {
                return wr3
            } else {
                return wr1
            }
        case 14:
            return amount
        default:
            return NSNumber(value: Double.greatestFiniteMagnitude)
        }
    }
}

public class KLineModel {
    var isNullData: Bool = false
    var modeType: Int = 0
    var rgb: UIColor = .clear
}

class CandleLinePriceData: KLineModel {
    var volume: NSNumber = 0.0
    var business: NSNumber = 0.0
    var change: NSNumber = 0.0
    var time: Int = 0
    var closePrice: NSNumber = 0.0
    var openPrice: NSNumber = 0.0
    var lowPrice: NSNumber = 0.0
    var highPrice: NSNumber = 0.0
}

class ColumnarPriceData: KLineModel {
    var lowPrice: NSNumber = 0.0
    var highPrice: NSNumber = 0.0
    var priceUp: Bool = false
}

class LinePriceData: KLineModel {
    var price: NSNumber = 0.0
}
