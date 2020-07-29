//
//  KlineIndexModel.swift
//  kline
//
//  Created by zhangj on 2019/8/11.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

class KLineTipModel {
    var lineTip: String = ""
    var color: UIColor = UIColor.clear
}

public class KlineIndexModel {
    public var boll_n_parameter: Int = 20
    public var boll_p_parameter: Int = 2
    
    public var macd_s_paramter: Int = 12
    public var macd_l_paramter: Int = 26
    public var macd_m_paramter: Int = 9
    
    public var kdj_n: Int = 14
    public var kdj_m1: Int = 1
    public var kdj_m2: Int = 3
    
    public var priceMaArray: [Int] = [5, 10, 30]
    public var volumeMaArray: [Int] = [5, 10]
    public var wrArray: [Int] = [14]
    public var rsiArray: [Int] = [14]
    
    public required init() { }
    
    var priceMaNoZeroArray: [Int] {
        return priceMaArray.filter { $0 > 0 }
    }
    
    var volumeMaNoZeroArray: [Int] {
        return volumeMaArray.filter { $0 > 0 }
    }
    
    var wrNoZeroArray: [Int] {
        return wrArray.filter { $0 > 0 }
    }
    
    var rsiNoZeroArray: [Int] {
        return rsiArray.filter { $0 > 0 }
    }

    func getTipArray(chartType: ChartType) -> [KLineTipModel] {
        var tips = [KLineTipModel]()
        if chartType == .assistant_macd {
            let tip = KLineTipModel()
            tip.color = ColorManager.shared.kColorSecondaryText
            tip.lineTip = "MACD(\(macd_s_paramter), \(macd_l_paramter), \(macd_m_paramter))"
            tips.append(tip)
        }
        if chartType == .assistant_kdj {
            let tip = KLineTipModel()
            tip.color = ColorManager.shared.kColorSecondaryText
            tip.lineTip = "KDJ(\(kdj_n), \(kdj_m1), \(kdj_m2))"
            tips.append(tip)
        }
        return tips
    }
    
    func lineName(for type: Int, index: Int) -> String {
        switch type {
        case 1:
            let num = priceMaArray[index-1]
            return "MA\(num)"
        case 2:
            let num = volumeMaArray[index-1]
            return "MA\(num)"
        case 3:
            return "BOLL"
        case 4:
            return "UB"
        case 5:
            return "LB"
        case 6:
            return "DIF"
        case 7:
            return "DEA"
        case 8:
            return "MACD"
        case 9:
            return "K"
        case 10:
            return "D"
        case 11:
            return "J"
        case 12:
            let num = rsiArray[index]
            return "RSI\(num)"
        case 13:
            let num = wrArray[index]
            return "WR\(num)"
        case 14:
            return "VOL"
        default:
            return ""
        }
        
    }
}
