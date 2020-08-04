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
    
    var rsi1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var rsi2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var rsi3: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var wr1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var wr2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var wr3: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var volMa1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var volMa2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var amountMa1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var amountMa2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var priceMa1: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var priceMa2: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var priceMa3: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var priceMa4: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var priceMa5: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var priceMa6: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var bollLb: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var bollUb: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var bollSummary: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var kdjJ: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var kdjD: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var kdjK: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var macdDea: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var macdDif: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var macdMacd: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var ema_small: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var ema_big: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    var ema_middle: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
    
    var priceUp: Bool {
        return open.doubleValue <= close.doubleValue
    }
    
    /// ["KDJ_K": 33, "WR_14": 23]
    var ext: [String: NSNumber] = [:]
    
    public init() { }
    
    func clearIndexData() {
        rsi1 = NSNumber(value: Double.greatestFiniteMagnitude)
        rsi2 = NSNumber(value: Double.greatestFiniteMagnitude)
        rsi3 = NSNumber(value: Double.greatestFiniteMagnitude)
        
        wr1 = NSNumber(value: Double.greatestFiniteMagnitude)
        wr2 = NSNumber(value: Double.greatestFiniteMagnitude)
        wr3 = NSNumber(value: Double.greatestFiniteMagnitude)
        
        volMa1 = NSNumber(value: Double.greatestFiniteMagnitude)
        volMa2 = NSNumber(value: Double.greatestFiniteMagnitude)
        
        amountMa1 = NSNumber(value: Double.greatestFiniteMagnitude)
        amountMa2 = NSNumber(value: Double.greatestFiniteMagnitude)
        
        priceMa1 = NSNumber(value: Double.greatestFiniteMagnitude)
        priceMa2 = NSNumber(value: Double.greatestFiniteMagnitude)
        priceMa3 = NSNumber(value: Double.greatestFiniteMagnitude)
        priceMa4 = NSNumber(value: Double.greatestFiniteMagnitude)
        priceMa5 = NSNumber(value: Double.greatestFiniteMagnitude)
        priceMa6 = NSNumber(value: Double.greatestFiniteMagnitude)
        
        bollLb = NSNumber(value: Double.greatestFiniteMagnitude)
        bollUb = NSNumber(value: Double.greatestFiniteMagnitude)
        bollSummary = NSNumber(value: Double.greatestFiniteMagnitude)
        
        kdjJ = NSNumber(value: Double.greatestFiniteMagnitude)
        kdjD = NSNumber(value: Double.greatestFiniteMagnitude)
        kdjK = NSNumber(value: Double.greatestFiniteMagnitude)
        
        macdDea = NSNumber(value: Double.greatestFiniteMagnitude)
        macdDif = NSNumber(value: Double.greatestFiniteMagnitude)
        macdMacd = NSNumber(value: Double.greatestFiniteMagnitude)
        
        ema_small = NSNumber(value: Double.greatestFiniteMagnitude)
        ema_big = NSNumber(value: Double.greatestFiniteMagnitude)
        ema_middle = NSNumber(value: Double.greatestFiniteMagnitude)
    }
    

    
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
    var changeRate: NSNumber = 0.0
    var time: Int = 0
    var closePrice: NSNumber = 0.0
    var openPrice: NSNumber = 0.0
    var lowPrice: NSNumber = 0.0
    var highPrice: NSNumber = 0.0
    var priceUp: Bool = false
}

class ColumnarPriceData: KLineModel {
    var lowPrice: NSNumber = 0.0
    var highPrice: NSNumber = 0.0
    var priceUp: Bool = false
}

class LinePriceData: KLineModel {
    var price: NSNumber = 0.0
}
