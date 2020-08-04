//
//  KlineViewDataSource.swift
//  kline
//
//  Created by zhang j on 2019/6/16.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation
import UIKit

public protocol KlineViewDataSourceDelegate: class {
    func refresh()
    func updateKline(reset: Bool)
}

open class KlineViewDataSource {
    public weak var delegate: KlineViewDataSourceDelegate?

    private var originDataPoolDic: [PeriodType: [KLineDataModel]] = [:]
    private var changeDic: [PeriodType: [Int: KLineDataChangeModel]] = [:]
    
    public var indexModel = KlineIndexModel()
    public var period: PeriodType = .min
    public var lineWidth: CGFloat = 7.0
    
    public var mainChartType: ChartType = .main_ma
    public var assistantChartType: ChartType = .assistant_rsi
    public var volumeChartType: ChartType = .volume
    
    private var queryMoreDate: Int = 0
    private var historyCurrentDate: Int = 0
    
    public init() { }
    
    func periodData(period: PeriodType) -> [KLineDataModel] {
        return originDataPoolDic[period] ?? []
    }
}

extension KlineViewDataSource {
    func getLatestTips(by chartType: ChartType, arrayIndex: Int) -> [KLineTipModel] {
        return []
    }
    
    var currentPeriod: PeriodType {
        return period
    }
    
    func change(maxWidth: CGFloat) {
        lineWidth = maxWidth
    }
    
    public func change(period: PeriodType) {
        self.period = period
    }
    
    func getData(from index: Int) -> KLineModel {
        return backData(type: 0, period: period, chartType: mainChartType, index: index, timeIndex: index)
    }
    
    var pricePrecision: Int {
        return 2
    }
    
    var amountPrecision: Int {
        return 6
    }
    
    /// - Parameters:
    ///   - index: 线所在图层index
    ///   - chartType: ChartType
    /// - Returns: KLine
    func assistantChartViewLine(from index: Int, chartType: ChartType) -> KLine {
        let type = KlineTypeCommon.lineType(for: chartType, index: index)
        var kLine: KLine
        switch type {
        case 0:
            if period == .timeline {
                kLine = AreaLine(type: .area)
            } else {
                kLine = CandleLine(type: .candle)
            }
        case 8:
            kLine = ColumnarLine(type: .separateColumnar)
        case 14:
            if period == .timeline {
                kLine = ColumnarLine(type: .minuteColumnar)
            } else {
                kLine = ColumnarLine(type: .columnar)
            }
        default:
            kLine = SolidLine(type: .solid)
            kLine.strokeColor = KlineTypeCommon.lineColor(for: chartType, index: index).cgColor
        }
        kLine.pricePrecision = pricePrecision
        kLine.index = index
        return kLine
    }
    
    var maxWidth: CGFloat {
        return lineWidth
    }
    
    var showType: Int {
        return 0
    }

    var pointCount: Int {
        return periodData(period: period).count
    }
    
    func index(of date: Int) -> Int? {
        return index(for: date, period: period)
    }
    
    func backArray(for chartType: ChartType, index: Int, start: Int, end: Int) -> [KLineModel] {
        let type = KlineTypeCommon.lineType(for: chartType, index: index)
        return backArray(type: type, period: period, chartType: chartType, index: index, start: start, end: end)
    }
    
    func backLastData(for chartType: ChartType, index: Int) -> KLineModel {
        let type = KlineTypeCommon.lineType(for: chartType, index: index)
        return backLastData(type: type, period: period, chartType: chartType, index: index)
    }
    
    func requestKline() {
//        marketDataManager.getRemoteServiceData()
    }
    
    func showTimes(for indexes: [Int]) -> [Int] {
        return showTimes(for: indexes, period: period)
    }
    
    
    func getTheLimitPrice(for chartType: ChartType, start: Int, end: Int, finish: (NSNumber, NSNumber) -> Void) {
        let count = numberOfAssistantLines(for: chartType)
        
        var maxPrice: NSNumber = 0
        var minPrice: NSNumber = NSNumber(value: Double.greatestFiniteMagnitude)
        var index = 0
        while index < count {
            let type = KlineTypeCommon.lineType(for: chartType, index: index)
            let kLineModels = backArray(type: type, period: period, chartType: chartType, index: index, start: start, end: end)
            
            for kLineModel in kLineModels {
                switch kLineModel {
                case let line as LinePriceData:
                    if !line.isNullData {
                        if maxPrice.compare(line.price) == .orderedAscending {
                            maxPrice = line.price
                        }
                        if minPrice.compare(line.price) == .orderedDescending {
                            minPrice = line.price
                        }
                    }
                case let candle as CandleLinePriceData:
                    if period == .timeline {
                        if maxPrice.compare(candle.closePrice) == .orderedAscending {
                            maxPrice = candle.closePrice
                        }
                        if minPrice.compare(candle.closePrice) == .orderedDescending {
                            minPrice = candle.closePrice
                        }
                    } else {
                        if maxPrice.compare(candle.highPrice) == .orderedAscending {
                            maxPrice = candle.highPrice
                        }
                        if minPrice.compare(candle.lowPrice) == .orderedDescending {
                            minPrice = candle.lowPrice
                        }
                    }
                case let columnar as ColumnarPriceData:
                    if !columnar.isNullData {
                        if maxPrice.compare(columnar.highPrice) == .orderedAscending {
                            maxPrice = columnar.highPrice
                        }
                        if minPrice.compare(columnar.lowPrice) == .orderedDescending {
                            minPrice = columnar.lowPrice
                        }
                    }
                default:
                    break
                }
            }
            
            index = index + 1
        }
        finish(maxPrice, minPrice)
    }
    
    func numberOfAssistantLines(for chartType: ChartType) -> Int {
        updateIndex(chartType: chartType, period: period)
                
        switch chartType {
        case .main_ma:
            if period == .timeline {
                return 1
            }
            return indexModel.priceMaArray.count + 1
        case .main_boll:
            if period == .timeline {
                return 1
            }
            return 4
        case .volume:
            if period == .timeline {
                return 1
            }
            return indexModel.volumeMaArray.count + 1
        case .assistant_macd, .assistant_kdj:
            return 3
        case .assistant_rsi:
            return indexModel.rsiArray.count
        case .assistant_wr:
            return indexModel.wrArray.count
        case .main:
            return 1
        default:
            return 0
        }
    }
    
    // TODO: number
    func tipModel(for data: KLineModel, chartType: ChartType, lineName: String) -> KLineTipModel {
        let tipModel = KLineTipModel()

        if !lineName.isEmpty && !data.isNullData {
            var value: NSNumber = 0
            
            tipModel.color = data.rgb
            
            if let line = data as? LinePriceData {
                value = line.price
            } else if let columnar = data as? ColumnarPriceData {
                if columnar.lowPrice.compare(NSNumber(value: 0)) == .orderedDescending {
                    value = columnar.lowPrice
                } else {
                    value = columnar.highPrice
                }
            }
            
            if chartType == .volume {
                let str = KLineNumberFormatter.format(volume: value, amountPrecision: amountPrecision)
                tipModel.lineTip = "\(lineName):\(str)"
            }
            else if chartType.rawValue > 3 {
                let str = KLineNumberFormatter.format(value, precision: 2)
                tipModel.lineTip = "\(lineName):\(str)"
            } else {
                let str = KLineNumberFormatter.format(value, precision: pricePrecision)
                tipModel.lineTip = "\(lineName):\(str)"
            }
        }
            
        return tipModel
    }
    
    func getTipArray(for chartType: ChartType) -> [KLineTipModel] {

        if chartType == .assistant_kdj {
            let tipModel = KLineTipModel()
            tipModel.color = ColorManager.shared.klineCnyRateColor
            tipModel.lineTip = "KDJ(\(indexModel.kdj_n),\(indexModel.kdj_m1),\(indexModel.kdj_m2))"
            return [tipModel]
        }
        if chartType == .assistant_macd {
            let tipModel = KLineTipModel()
            tipModel.color = ColorManager.shared.klineCnyRateColor
            tipModel.lineTip = "MACD(\(indexModel.macd_s_paramter),\(indexModel.macd_l_paramter),\(indexModel.macd_m_paramter))"
            return [tipModel]
        }
        return []
    }
    
    /// 获取最新的指标数据
    func getLatestTips(by chartType: ChartType) -> [KLineTipModel] {
        guard !periodData(period: period).isEmpty else {
            return []
        }
        let numberOfLines = numberOfAssistantLines(for: chartType)
        var tips = indexModel.getTipArray(chartType: chartType)
        for index in stride(from: 0, to: numberOfLines, by: 1) {
            let type = KlineTypeCommon.lineType(for: chartType, index: index)
            let data = backLastData(type: type, period: period, chartType: chartType, index: index)
            let lineName = indexModel.lineName(for: type, index: index)
            let tip = tipModel(for: data, chartType: chartType, lineName: lineName)
            tips.append(tip)
        }
        return tips
    }
    
    /// 长按显示的指标数据
    func getCurrentTips(by chartType: ChartType, arrayIndex: Int) -> [KLineTipModel] {
        guard !periodData(period: period).isEmpty else {
            return []
        }
        let numberOfLines = numberOfAssistantLines(for: chartType)
        var tips = indexModel.getTipArray(chartType: chartType)
        for index in stride(from: 0, to: numberOfLines, by: 1) {
            let type = KlineTypeCommon.lineType(for: chartType, index: index)
            let data = backData(type: type, period: period, chartType: chartType, index: index, timeIndex: arrayIndex)
            let lineName = indexModel.lineName(for: type, index: index)
            if !lineName.isEmpty {
                let tip = tipModel(for: data, chartType: chartType, lineName: lineName)
                tip.color = KlineTypeCommon.lineColor(for: chartType, index: index)
                tips.append(tip)
            }
        }
        return tips
    }
    
    /// 最新的指标数据
    func getNewCurrentViewByType(_ chartType: ChartType) -> [KLineTipModel] {
        guard !periodData(period: period).isEmpty else {
            return []
        }
        var tips = indexModel.getTipArray(chartType: chartType)
        let numberOfLines = numberOfAssistantLines(for: chartType)
        for index in 0..<numberOfLines {
            let type = KlineTypeCommon.lineType(for: chartType, index: index)
            let data = backLastData(type: type, period: period, chartType: chartType, index: index)
            let lineName = indexModel.lineName(for: type, index: index)
            if !lineName.isEmpty {
                let tip = tipModel(for: data, chartType: chartType, lineName: lineName)
                tip.color = KlineTypeCommon.lineColor(for: chartType, index: index)
                tips.append(tip)
            }
        }
        return tips
    }
    
    func releaseIndex(from startIndex: Int, datas: [KLineDataModel]) {
        guard startIndex < datas.count else {
            return
        }
        let endIndex = datas.count - 1
        let array = datas[startIndex ... endIndex]
        for k in array {
            k.clearIndexData()
        }
    }
}

extension KlineViewDataSource {
    func update(kline: PeriodType, resetHistory: Bool) {
        if kline != period {
            return
        } else {
            
        }
        delegate?.updateKline(reset: resetHistory)
    }
}

extension KlineViewDataSource {
    func backArray(type: Int, period: PeriodType, chartType: ChartType, index: Int, start: Int, end: Int) -> [KLineModel] {
        var klineModels: [KLineModel] = []
        let datas = periodData(period: period)

        guard end >= start else {
            return klineModels
        }
        guard start <= datas.count else {
            return klineModels
        }
        
        let endIndex = end >= datas.count ? datas.count - 1 : end
        
        for i in stride(from: start, through: endIndex, by: 1) {
            let data = KlineDataConversionCommon.kLineModel(for: datas[i], type: type, index: index, chartType: chartType, period: period)
            klineModels.append(data)
        }
    
        return klineModels
    }
    
    func backLastData(type: Int, period: PeriodType, chartType: ChartType, index: Int) -> KLineModel {
        if let last = periodData(period: period).last {
            let kLineModel = KlineDataConversionCommon.kLineModel(for: last, type: type, index: index, chartType: chartType, period: period)
            return kLineModel
        }
        let klineModel = KLineModel()
        klineModel.isNullData = true
        return klineModel
    }
    
    func backData(type: Int, period: PeriodType, chartType: ChartType, index: Int, timeIndex: Int) -> KLineModel {
        let klineDatas = periodData(period: period)
        if timeIndex < klineDatas.count {
            return KlineDataConversionCommon.kLineModel(for: klineDatas[timeIndex], type: type, index: index, chartType: chartType, period: period)
        }
        let klineModel = KLineModel()
        klineModel.isNullData = true
        return klineModel
    }
    
    func index(for date: Int, period: PeriodType) -> Int {
        return periodData(period: period).firstIndex(where: { $0.time == date }) ?? 0
    }
    
    func updateIndex(chartType: ChartType, period: PeriodType) {
        let klineDatas = periodData(period: period)
        HBKlineIndexCalculateCommon.update(index: indexModel, chartType: chartType, datas: klineDatas)
    }
    
    func showTimes(for indexes: [Int], period: PeriodType) -> [Int] {
        var times: [Int] = []
        let periodDatas = periodData(period: period)
        for index in indexes {
            if index < periodDatas.count {
                times.append(periodDatas[index].time)
            }
        }
        return times
    }
    
    // TODO: insert datas at index 0
    
    public func append(klines: [KLineDataModel], period: PeriodType, bSub: Bool, deleteHistory: Bool) {
        var originData = periodData(period: period)
        if originData.isEmpty && bSub { // 防止更新的数据先到达，历史数据后到达造成线先展示一条k线
            return
        }
        
        for kline in klines {
            kline.change = kline.close.subtracting(kline.open)
            kline.changeRate = kline.change.dividing(by: kline.open).multiplying(by: 100)
        }
        
        if originData.isEmpty || deleteHistory {
            originDataPoolDic[period] = klines
            changeDic.removeAll()
        } else {
            if bSub {
                for kline in klines {
                    if let last = originData.last {
                        if last.time == kline.time {
                            initTrendAnimation(from: last, to: kline, period: period)
                        } else if last.time < kline.time {
                            originData.append(kline)
                        }
                    }
                }
                
                originDataPoolDic[period] = originData
            } else {
                originDataPoolDic[period] = klines
            }
        }
        
        releaseIndex(from: max(0, originData.count - klines.count - 1), datas: originData)
        updataShowTrend(period: period, resetHistory: deleteHistory)
    }
    
    /// 变更动画
    func initTrendAnimation(from: KLineDataModel, to: KLineDataModel, period: PeriodType) {
        
        let changeModel = KLineDataChangeModel()
        
        var changeData = changeDic[period] ?? [:]
        
        let step: NSDecimalNumber = 6.0
        changeModel.realData = to
        changeModel.lastNum = 6
        changeModel.changeOpen = to.open.subtracting(from.open).dividing(by: step)
        changeModel.changeClose = to.close.subtracting(from.close).dividing(by: step)
        changeModel.changeLow = to.low.subtracting(from.low).dividing(by: step)
        changeModel.changeHigh = to.high.subtracting(from.high).dividing(by: step)
        changeModel.changeAmount = to.amount.subtracting(from.amount).dividing(by: step)
        
        changeData[from.time] = changeModel
        changeDic[period] = changeData
        
        changeTrendAnimation(from: from, to: changeModel)
    }
    
    func changeTrendAnimation(from: KLineDataModel, to: KLineDataChangeModel) {
        if to.lastNum == 1 {
            let realData = to.realData
            from.open = realData.open
            from.close = realData.close
            from.high = realData.high
            from.low = realData.low
            from.amount = realData.amount
            from.change = realData.change
            from.changeRate = realData.changeRate
        } else {
            from.open = from.open.adding(to.changeOpen)
            from.close = from.close.adding(to.changeClose)
            from.high = from.high.adding(to.changeHigh)
            from.low = from.low.adding(to.changeLow)
            from.amount = from.amount.adding(to.changeAmount)
            from.change = from.close.subtracting(from.open)
            if from.change != 0 {
                from.changeRate = from.change.dividing(by: from.open).multiplying(by: 100)
            } else {
                from.changeRate = 0.0
            }
        }
        
        to.lastNum = to.lastNum - 1
    }
    
    func updataShowTrend(period: PeriodType, resetHistory: Bool) {
        update(kline: period, resetHistory: resetHistory)
        
        if let changeData = changeDic[period] {
            if changeData.keys.count > 0 {
                asyncData(period: period)
            }
        }
    }
    
    /// 异步操作，注意bug
    func asyncData(period: PeriodType) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.015) {
            if var changeData = self.changeDic[period] {
                let copyChangeData = changeData
                let periodData = self.periodData(period: period)
                for (_, value) in copyChangeData {
                    for od in periodData {
                        if value.realData.time == od.time {
                            if value.lastNum == 0 {
                                changeData.removeValue(forKey: value.realData.time)
                            } else {
                                self.changeTrendAnimation(from: od, to: value)
                            }
                        }
                    }
                }
                self.changeDic[period] = changeData
                self.releaseIndex(from: max(0, periodData.count - 1), datas: self.periodData(period: period))
                self.updataShowTrend(period: period, resetHistory: false)
            }
        }
    }
}
