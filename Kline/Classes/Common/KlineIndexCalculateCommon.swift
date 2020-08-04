//
//  KlineIndexCalculateCommon.swift
//  kline
//
//  Created by zhang j on 2019/8/14.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

struct IndicatorCaculator {
    
}

struct HBKlineIndexCalculateCommon {
    static func update(index: KlineIndexModel, chartType: ChartType, datas: [KLineDataModel]) {
        switch chartType {
        case .main_ma:
            updateMA(index: index, datas: datas)
        case .main_boll:
            updateBOLL(index: index, datas: datas)
        case .volume:
            updateAmount(index: index, datas: datas)
        case .assistant_macd:
            updateMACD(index: index, datas: datas)
        case .assistant_kdj:
            updateKDJ(index: index, datas: datas)
        case .assistant_rsi:
            updateRSI(index: index, datas: datas)
        case .assistant_wr:
            updateWR(index: index, datas: datas)
        default:
            break
        }
    }
    
    static func updateMA(index: KlineIndexModel, datas: [KLineDataModel]) {
        for (i, num) in index.priceMaNoZeroArray.enumerated() {
            for (j, data) in datas.enumerated() {
                if j < num - 1 { continue }
                switch i {
                case 0:
                    if !data.priceMa1.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                case 1:
                    if !data.priceMa2.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                case 2:
                    if !data.priceMa3.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                case 3:
                    if !data.priceMa4.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                case 4:
                    if !data.priceMa5.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                case 5:
                    if !data.priceMa6.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                default:
                    break
                }
                
                var closePrice: NSDecimalNumber = 0
                let endIndex = (j + 1 - num) >= 0 ? (j + 1 - num) : 0
                for k in stride(from: j, through: endIndex, by: -1) {
                    closePrice = closePrice.adding(datas[k].close)
                }
                let ma = closePrice.dividing(by: NSDecimalNumber(value: num))
                switch i {
                case 0:
                    data.priceMa1 = ma
                case 1:
                    data.priceMa2 = ma
                case 2:
                    data.priceMa3 = ma
                case 3:
                    data.priceMa4 = ma
                case 4:
                    data.priceMa5 = ma
                case 5:
                    data.priceMa6 = ma
                default:
                    break
                }
            }
        }
    }
    
    static func updateAmount(index: KlineIndexModel, datas: [KLineDataModel]) {
        for (i, num) in index.volumeMaArray.filter({ $0 > 0 }).enumerated() {
            for (j, data) in datas.enumerated() {
                if j < num - 1 {
                    continue
                }
                if i == 0 {
                    if !data.amountMa1.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                } else {
                    if !data.amountMa2.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                }
                
                var vol: NSDecimalNumber = 0
                let endIndex = (j + 1 - num) >= 0 ? (j + 1 - num) : 0
                for k in stride(from: j, through: endIndex, by: -1) {
                    vol = vol.adding(datas[k].amount)
                }
                let ma = vol.dividing(by: NSDecimalNumber(value: num))
                if i == 0 {
                    data.amountMa1 = ma
                } else {
                    data.amountMa2 = ma
                }
            }
        }
    }
    
    static func updateBOLL(index: KlineIndexModel, datas: [KLineDataModel]) {
        for (i, data) in datas.enumerated() {
            if i < index.boll_n_parameter - 1 {
                continue
            }
            if !data.bollSummary.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                continue
            }
            data.bollSummary = calculateAveragePrice(count: index.boll_n_parameter, endIndex: i, datas: datas)
            data.bollUb = NSNumber(value: data.bollSummary.doubleValue + calculateStd(num: index.boll_n_parameter, arg: index.boll_p_parameter, index: i, datas: datas).doubleValue * Double(index.boll_p_parameter))
            data.bollLb = NSNumber(value: data.bollSummary.doubleValue - calculateStd(num: index.boll_n_parameter, arg: index.boll_p_parameter, index: i, datas: datas).doubleValue * Double(index.boll_p_parameter))
        }
    }
    
    private static func calculateStd(num: Int, arg: Int, index: Int, datas: [KLineDataModel]) -> NSNumber {
        var result: Double = 0.0
        if index < (num - 1) {
            return NSNumber(value: result)
        }
        var sum: Double = 0.0
        var boll_ma: Double = 0.0
        
        var i = index
        while i > (index - num) {
            let data = datas[i]
            if boll_ma == 0.0 {
                boll_ma = data.bollSummary.doubleValue
            }
            sum += pow(data.close.doubleValue - boll_ma, Double(arg))
            i -= 1
        }
        result = sqrt(sum / Double(num))
        return NSNumber(value: result)
    }
    
    static func calculateAveragePrice(count: Int, endIndex: Int, datas: [KLineDataModel]) -> NSNumber {
        var result: Double = 0.0
        if endIndex < count - 1 {
            return NSNumber(value: result)
        }
        
        var sum: Double = 0.0
        var i = endIndex
        while i > endIndex - count {
            sum += datas[i].close.doubleValue
            i -= 1
        }
        result = sum / Double(count)
        return NSNumber(value: result)
    }
    
    static func updateMACD(index: KlineIndexModel, datas: [KLineDataModel]) {
        for (i, data) in datas.enumerated() {
            if i < index.macd_l_paramter - 1 {
                continue
            }
            if i < index.macd_l_paramter + index.macd_m_paramter - 2 {
                if !data.macdDif.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                    continue
                }
                self.calculateExpma(index: i, emaSmall: index.macd_s_paramter, emaBig: index.macd_l_paramter, datas: datas)
                data.macdDif = NSNumber(value: data.ema_small.doubleValue - data.ema_big.doubleValue)
            } else {
                if !data.macdMacd.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                    continue
                }
                self.calculateExpma(index: i, emaSmall: index.macd_s_paramter, emaBig: index.macd_l_paramter, datas: datas)
                data.macdDif = NSNumber(value: data.ema_small.doubleValue - data.ema_big.doubleValue)
                self.calculateDea(index: index, argu: index.macd_m_paramter, end: i, datas: datas)
                data.macdMacd = NSNumber(value: (data.macdDif.doubleValue - data.macdDea.doubleValue))
            }
        }
    }
    
    /**
     计算EMA的算法
     
     @param index 需要计算的下标
     @param emaSmall 默认12
     @param emaBig 默认26
     @param datas 需要处理的数据
     */
    private static func calculateExpma(index: Int, emaSmall: Int, emaBig: Int, datas: [KLineDataModel]) {
        for (i, data) in datas.enumerated() {
            if i == 0 {
                data.ema_small = data.close
                data.ema_big = data.close
            } else {
                let prev = datas[i - 1]
                data.ema_small = NSNumber(value: (2.0 / Double(emaSmall + 1)) * (data.close.doubleValue - prev.ema_small.doubleValue) + prev.ema_small.doubleValue)
                data.ema_big = NSNumber(value: (2.0 / Double(emaBig + 1)) * (data.close.doubleValue - prev.ema_big.doubleValue) + prev.ema_big.doubleValue)
            }
        }
    }
    
    /**
     DIF的EMA(DEA)

     @param argu 计算平均值的平滑参数
     @param endIndex 结束时的index
     @param datas 需要处理的数据
     */
    private static func calculateDea(index: KlineIndexModel, argu: Int, end endIndex: Int, datas: [KLineDataModel]) {
        
        let endModel = datas[endIndex]
        if endIndex == index.macd_l_paramter + index.macd_m_paramter - 2 {
            // 第一日的dea为0
            endModel.macdDea = NSNumber(value: 0.0)
        } else {
            let prev = datas[endIndex - 1]
            let last_dea  = prev.macdDea.doubleValue * (8.0 / 10.0)
            let end_dif   = endModel.macdDif.doubleValue * (2.0 / 10.0)
            endModel.macdDea  = NSNumber(value: last_dea + end_dif)
        }
    }
    
    static func updateKDJ(index: KlineIndexModel, datas: [KLineDataModel]) {
        var prev_k: Double = 50
        var prev_d: Double = 50
        
        for (i, data) in datas.enumerated() {
            if i < index.kdj_n - 1 { continue }
            
            if !data.kdjD.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                continue
            }
            //计算RSV值
            if let rsv = self.getRSV(index.kdj_n, index: i, datas: datas) {
                //计算K,D,J值
                let k: Double = (2 * prev_k + rsv) / 3
                let d: Double = (2 * prev_d + k) / 3
                let j: Double = 3 * k - 2 * d
                
                prev_k = k
                prev_d = d
                
                data.kdjK = NSNumber(value: k)
                data.kdjD = NSNumber(value: d)
                data.kdjJ = NSNumber(value: j)
            }
        }
    }
    
    static func updateRSI(index: KlineIndexModel, datas: [KLineDataModel]) {
        let indexModel = index
        for (i, num) in indexModel.rsiArray.filter({ $0 > 0 }).enumerated() {
            var rsi: Double = 0
            var rsiABSEma: Double = 0
            var rsiMaxEma: Double = 0
            
            for (index, data) in datas.enumerated() {
                if index < num { continue }
                
                let rMax = max(0, data.close.doubleValue - datas[index-1].close.doubleValue)
                let rAbs = abs(data.close.doubleValue - datas[index-1].close.doubleValue)
                
                rsiMaxEma = (rMax + (Double(num) - 1) * rsiMaxEma) / Double(num)
                rsiABSEma = (rAbs + (Double(num) - 1) * rsiABSEma) / Double(num)
                rsi = (rsiMaxEma / rsiABSEma) * 100
                if i == 0 {
                    data.rsi1 = NSNumber(value: rsi)
                } else if i == 1 {
                    data.rsi2 = NSNumber(value: rsi)
                } else {
                    data.rsi3 = NSNumber(value: rsi)
                }
            }
        }
    }
    
    static func updateWR(index: KlineIndexModel, datas: [KLineDataModel]) {
        let indexModel = index
        for (i, num) in indexModel.wrArray.enumerated() {
            for (index, data) in datas.enumerated() {
                if index < num { continue }
                
                if i == 0 {
                    if !data.wr1.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                } else if i == 1 {
                    if !data.wr2.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                } else {
                    if !data.wr3.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                        continue
                    }
                }
                
                let startIndex = index - num + 1
                var highPrice = Double.leastNormalMagnitude, lowPrice = Double.greatestFiniteMagnitude

                for mIndex in startIndex...index {
                    highPrice = max(highPrice, datas[mIndex].high.doubleValue)
                    lowPrice = min(lowPrice, datas[mIndex].low.doubleValue)
                }

                let wr = 100 * (highPrice - data.close.doubleValue) / (highPrice - lowPrice)
                if i == 0 {
                    data.wr1 = NSNumber(value: wr)
                } else if i == 1 {
                    data.wr2 = NSNumber(value: wr)
                } else {
                    data.wr3 = NSNumber(value: wr)
                }
            }
        }
    }
}

extension HBKlineIndexCalculateCommon {
    static func getRSV(_ num: Int, index: Int, datas: [KLineDataModel]) -> Double? {
        var rsv: Double = 0
        let c = datas[index].close.doubleValue
        var h = datas[index].high.doubleValue
        var l = datas[index].low.doubleValue
        
        let block: (Int) -> Void = {
            (i) -> Void in
            
            let item = datas[i]
            
            if item.high.doubleValue > h {
                h = item.high.doubleValue
            }
            
            if item.low.doubleValue < l {
                l = item.low.doubleValue
            }
        }
        
        if index + 1 >= num {    //index + 1 >= N，累计N天内的
            //计算num天数内最低价，最高价
            for i in stride(from: index, through: index + 1 - num, by: -1) {
                block(i)
            }
        } else {                //index + 1 < N，累计index + 1天内的
            //计算index天数内最低价，最高价
            for i in stride(from: index, through: 0, by: -1) {
                block(i)
            }
        }
        
        if h != l {
            rsv = (c - l) / (h - l) * 100
        }
        return rsv
    }
}
