//
//  ChartView.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

enum ChartViewType {
    case candle
    case timeline
    case volume
    case assistant
}

class ChartView: UIView {
    
    let type: ChartViewType
    
    weak var dataSource: ChartViewDataSource!
    
    var candleLine: KLine?
    
    var kLines: [KLine] = []
    
    var maxPrice: NSNumber = 0
    var minPrice: NSNumber = 0
    
    deinit {
        print("ChartView deinit")
    }
    
    init(type: ChartViewType) {
        self.type = type
        super.init(frame: CGRect.zero)
//        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        candleLine?.frame = bounds
        candleLine?.setNeedsDisplay()
    }
    
//    func setup() {
//        backgroundColor = .clear
//
//        switch type {
//        case .candle:
//            candleLine = CandleLine()
//            layer.addSublayer(candleLine!)
//            kLines.append(candleLine!)
//        default:
//            break
//        }
//    }
    
    func getCandle(for point: CGPoint) -> LineData {
        return candleLine!.getCandleClosePoint(by: point)
    }
}


extension ChartView {
    func zoomKline(width: CGFloat) {
        for kLine in kLines {
            if kLine is CandleLine || kLine is ColumnarLine {
                kLine.lineWidth = width
                kLine.updateLineWidth(width)
            }
        }
    }
    
    func updatePoints() {
        for (index, kLine) in kLines.enumerated() {
            dataSource.updatePoints(of: self, kLine: kLine, atIndex: index)
            kLine.setNeedsDisplay()
        }
    }
    
    func reloadSubViews() {
        kLines.forEach { $0.removeFromSuperlayer() }
        kLines.removeAll()
        for index in stride(from: 0, to: dataSource.numberOfLines(in: self), by: 1) {
            let kLine = dataSource.kLine(for: self, atIndex: index)
            kLines.append(kLine)
            kLine.frame = bounds
            layer.addSublayer(kLine)
            
            switch kLine {
            case is SolidLine:
                kLine.lineWidth = 1.0
            case is CandleLine:
                kLine.updateLineWidth(dataSource.currentMaxWidth)
                candleLine = kLine
            case is ColumnarLine:
                kLine.updateLineWidth(dataSource.currentMaxWidth)
            case is AreaLine:
                candleLine = kLine
            default:
                break
            }
        }
    }
}
