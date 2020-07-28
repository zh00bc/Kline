//
//  ChartDataManager.swift
//  kline
//
//  Created by zhangj on 2020/7/26.
//  Copyright © 2020 zhangj. All rights reserved.
//

import Foundation

protocol MarketDataManagerDelegate: class {
    func update(kline: PeriodType, resetHistory: Bool)
}

open class MarketDataManager {
    private var originDataPoolDic: [PeriodType: [KLineDataModel]] = [:]
    private var changeDic: [PeriodType: [Int: KLineDataChangeModel]] = [:]
    public var index = KlineIndexModel()
    public var period: PeriodType = .min
    
    
    weak var delegate: MarketDataManagerDelegate?

    deinit {
        debugPrint("ChartDataSource deinit")
    }
    
    public init() { }
    
    func periodData(period: PeriodType) -> [KLineDataModel] {
        return originDataPoolDic[period] ?? []
    }
    
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
        return KLineModel()
    }
    
    func backData(type: Int, period: PeriodType, chartType: ChartType, index: Int, timeIndex: Int) -> KLineModel {
        let klineDatas = periodData(period: period)
        if index < klineDatas.count {
            return KlineDataConversionCommon.kLineModel(for: klineDatas[index], type: type, index: index, chartType: chartType, period: period)
        }
        return KLineModel()
    }
    
    func index(for date: Int, period: PeriodType) -> Int {
        return periodData(period: period).firstIndex(where: { $0.time == date }) ?? 0
    }
    
    func updateIndex(chartType: ChartType, period: PeriodType) {
        let klineDatas = periodData(period: period)
        HBKlineIndexCalculateCommon.update(index: self.index, chartType: chartType, datas: klineDatas)
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
    
    public func append(klines: [KLineDataModel], period: PeriodType, bSub: Bool, deleteHistory: Bool) {
        for kline in klines {
            kline.change = kline.close.subtracting(kline.open)
            kline.changeRate = kline.change.dividing(by: kline.open.multiplying(by: 100))
        }
        
        var originData = periodData(period: period)
        if originData.count == 0 || deleteHistory {
            originDataPoolDic[period] = klines
            changeDic.removeAll()
        } else {
            if bSub {
                if let pLast = originData.last, let latest = klines.first {
                    if pLast.time == latest.time {
                        initTrendAnimation(from: pLast, to: latest, period: period)
                    } else {
                        originData.append(latest)
                    }
                    originDataPoolDic[period] = originData
                }
            } else {
                originDataPoolDic[period] = klines
            }
        }
                
        updataShowTrend(period: period, resetHistory: deleteHistory)
    }
    
    /// 变更动画
    func initTrendAnimation(from: KLineDataModel, to: KLineDataModel, period: PeriodType) {
        var changeModel: KLineDataChangeModel
        
        var changeData = changeDic[period]
        if changeData == nil {
            changeData = [:]
        }
        
        if let lastChangeModel = changeData![from.time] {
            changeModel = lastChangeModel
        } else {
            changeModel = KLineDataChangeModel()
        }
        
        let step: NSDecimalNumber = 6.0
        changeModel.realData = to
        changeModel.lastNum = 6
        changeModel.changeOpen = to.open.subtracting(from.open).dividing(by: step)
        changeModel.changeClose = to.close.subtracting(from.close).dividing(by: step)
        changeModel.changeLow = to.low.subtracting(from.low).dividing(by: step)
        changeModel.changeHigh = to.high.subtracting(from.high).dividing(by: step)
        changeModel.changeAmount = to.amount.subtracting(from.amount).dividing(by: step)
        
        changeData![from.time] = changeModel
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
        delegate?.update(kline: period, resetHistory: resetHistory)
        
        if let changeData = changeDic[period] {
            if changeData.keys.count > 0 {
                asyncData(period: period)
            }
        }
    }
    
    func asyncData(period: PeriodType) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.015) {
            if var changeData = self.changeDic[period] {
                let copyChangeData = changeData
                for (_, value) in copyChangeData {
                    var originData = self.periodData(period: period)
                    for od in self.periodData(period: period) {
                        if value.realData.time == od.time {
                            self.changeTrendAnimation(from: od, to: value)
                            if value.lastNum == 0 {
                                originData.removeLast()
                                originData.append(value.realData)
                                changeData.removeValue(forKey: value.realData.time)
                            }
                        }
                    }
                    self.originDataPoolDic[period] = originData
                }
                self.changeDic[period] = changeData
                
                self.updataShowTrend(period: period, resetHistory: false)
            }
        }
    }
}
