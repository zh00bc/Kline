//
//  KlineDataConversionCommon.swift
//  kline
//
//  Created by zhangj on 2019/8/11.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation

struct KlineDataConversionCommon {
    static func kLineModel(for data: KLineDataModel, type: Int, index: Int, chartType: ChartType, period: PeriodType) -> KLineModel {
        var lineData: KLineModel
        switch type {
        case 0:
            lineData = candle(with: data)
        case 8, 14:
            lineData = columnar(with: data, type: type, period: period)
        default:
            lineData = line(with: data, type: type, index: index, chartType: chartType)
        }
        return lineData
    }
    
    static func candle(with data: KLineDataModel) -> CandleLinePriceData {
        let candle = CandleLinePriceData()
        candle.highPrice = data.high
        candle.lowPrice = data.low
        candle.openPrice = data.open
        candle.closePrice = data.close
        candle.time = data.time
        candle.change = data.change
        candle.changeRate = data.changeRate
        candle.volume = data.amount
        candle.priceUp = data.priceUp
        return candle
    }
    
    // TODO: null data
    static func columnar(with data: KLineDataModel, type: Int, period: PeriodType) -> ColumnarPriceData {
        let columnar = ColumnarPriceData()
        
        columnar.highPrice = data.amount
        columnar.lowPrice = 0.0
        
        let d = data.getValue(for: type, index: 0)
        columnar.rgb = ColorManager.shared.klinePrimaryTextColor
        
        if type == 14 { /// volume
            if period == .timeline {
                /// 分时线交易量柱状图颜色不一样
                columnar.priceUp = false
            } else {
                columnar.priceUp = data.priceUp
            }
            
            columnar.highPrice = d
        } else if type == 8 { /// macd
            if d.compare(NSNumber(value: 0)) == .orderedDescending {
                columnar.highPrice = d
                columnar.lowPrice = 0
                columnar.priceUp = true
            } else {
                columnar.highPrice = 0
                columnar.lowPrice = d
                columnar.priceUp = false
            }
            
            if d.isEqual(to: NSNumber(value: Double.greatestFiniteMagnitude)) {
                columnar.isNullData = true
            }
        } else {
            columnar.isNullData = true
        }
                
        return columnar
    }
    
    static func line(with data: KLineDataModel, type: Int, index: Int, chartType: ChartType) -> LinePriceData {
        let line = LinePriceData()
        let d = data.getValue(for: type, index: index)
        
        if d.doubleValue != Double.greatestFiniteMagnitude {
            line.price = d
        } else {
            line.isNullData = true
        }
        
        return line
    }
}
