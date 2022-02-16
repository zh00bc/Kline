//
//  SlitherViewDataSource.swift
//  kline
//
//  Created by zhang j on 2019/6/15.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

//public protocol ChartDataSource: class {
//    var pointCount: Int { get }
//    var mainChartType: ChartType { get }
//    var volumeChartType: ChartType { get }
//    var assistantChartType: ChartType { get }
//    var periodType: PeriodType { get }
//    var pricePrecision: Int { get }
//    var amountPrecision: Int { get }
//
//    var originDataPoolDic: [Int: [KLineDataModel]] { get set }
//    var changeDic: [Int: [Int: KLineDataChangeModel]] { get set }
//
//    var index: KlineIndexModel { get }
//}

protocol SlitherViewDataSource: AnyObject {
    
    var pointCount: Int { get }
    
    var maxWidth: CGFloat { get }
    
    var mainChartType: ChartType { get }
    
    var volumeChartType: ChartType { get }
    
    var assistantChartType: ChartType { get }
    
    var currentPeriod: PeriodType { get }
        
    var pricePrecision: Int { get }
    
    var amountPrecision: Int { get }
    
    func index(of date: Int) -> Int?
    
    func change(maxWidth: CGFloat)
    
    func backArray(for chartType: ChartType, index: Int, start: Int, end: Int) -> [KLineModel]
    
    func backLastData(for chartType: ChartType, index: Int) -> KLineModel
    
    func getData(from index: Int) -> KLineModel
    
    func showTimes(for indexes: [Int]) -> [Int]
    
    func requestKline()
    
    func getTheLimitPrice(for chartType: ChartType, start: Int, end: Int, finish: (NSNumber, NSNumber) -> Void)
    
    func assistantChartViewLine(from index: Int, chartType: ChartType) -> KLine
    
    func numberOfAssistantLines(for chartType: ChartType) -> Int
    
    func getLatestTips(by chartType: ChartType, arrayIndex: Int) -> [KLineTipModel]
    func getCurrentTips(by chartType: ChartType, arrayIndex: Int) -> [KLineTipModel]
    func getNewCurrentViewByType(_ type: ChartType) -> [KLineTipModel]
}

