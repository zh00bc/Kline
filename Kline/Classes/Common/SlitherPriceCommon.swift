//
//  XLSlitherPriceCommon.swift
//  kline
//
//  Created by zhang j on 2019/8/9.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation
import UIKit

struct SlitherPriceCommon {
    static func getCandleData(data: CandleLinePriceData, chartView: ChartView, dValue: Double, x: Double, isMainView: Bool, index: Int) -> CandleData {
        let candle = CandleData()
        candle.highPoint = CGPoint(x: x, y: getY(from: chartView, dValue: dValue, current: data.highPrice.doubleValue, isMainView: isMainView))
        candle.lowPoint = CGPoint(x: x, y: getY(from: chartView, dValue: dValue, current: data.lowPrice.doubleValue, isMainView: isMainView))
        candle.openPoint = CGPoint(x: x, y: getY(from: chartView, dValue: dValue, current: data.openPrice.doubleValue, isMainView: isMainView))
        candle.closePoint = CGPoint(x: x, y: getY(from: chartView, dValue: dValue, current: data.closePrice.doubleValue, isMainView: isMainView))
        
        candle.highPrice = data.highPrice
        candle.lowPrice = data.lowPrice
        candle.nDataIndex = index
        return candle
    }
    
    static func getColumnarData(data: ColumnarPriceData, chartView: ChartView, dValue: Double, x: Double, isMainView: Bool) -> ColumnarData {
        let columnar = ColumnarData()
        columnar.lowPoint = CGPoint(x: x, y: getY(from: chartView, dValue: dValue, current: data.lowPrice.doubleValue, isMainView: isMainView))
        columnar.highPoint = CGPoint(x: x, y: getY(from: chartView, dValue: dValue, current: data.highPrice.doubleValue, isMainView: isMainView))
        columnar.isNullData = data.isNullData
        columnar.priceUp = data.priceUp
        return columnar
    }
    
    static func getSolidData(data: LinePriceData, chartView: ChartView, dValue: Double, x: Double, isMainView: Bool) -> LineData {
        let lineData = LineData()
        lineData.x = x
        lineData.y = getY(from: chartView, dValue: dValue, current: data.price.doubleValue, isMainView: isMainView)
        lineData.isNullData = data.isNullData
        return lineData
    }
    
    static func getAreaData(data: CandleLinePriceData, chartView: ChartView, dValue: Double, x: Double, isMainView: Bool, index: Int, lastData: CandleLinePriceData) -> LineData {
        let lineData = LineData()
        lineData.x = x
        lineData.y = getY(from: chartView, dValue: dValue, current: data.closePrice.doubleValue, isMainView: isMainView)
        lineData.nDataIndex = index
        //TODO: bColorDeep
        if Calendar.current.isDate(Date(timeIntervalSince1970: TimeInterval(data.time)),
                                   inSameDayAs: Date(timeIntervalSince1970: TimeInterval(lastData.time))) {
            lineData.bColorDeep = true
        } else {
            lineData.bColorDeep = false
        }
        return lineData
    }
    
    static func getY(from chartView: ChartView, dValue: Double, current: Double, isMainView: Bool) -> Double {
        let min = chartView.minPrice.doubleValue
        var height = Double(chartView.bounds.height)
        let proportion = (current - min) / dValue
        var a: Double

        if isMainView {
            a = proportion * Double(height - Double(Constants.mainChartTopSpace + Constants.mainChartBottomSpace))
            height = height - Double(Constants.mainChartTopSpace)
        } else {
            a = proportion * height
        }
        
        return height - a
    }
}
