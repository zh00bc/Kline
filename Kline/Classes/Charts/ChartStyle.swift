//
//  KlineStyle.swift
//  Kline
//
//  Created by Zhangj on 2021/1/25.
//

import UIKit

public class ChartStyle {
    public var mainChartGradientColors: [CGColor] = []
    public var volumeChartGradientColors: [CGColor] = []
    public var assistantChartGradientColors: [CGColor] = []
    public var numberViewLineColor: UIColor = UIColor(hex: "#82869E").withAlphaComponent(0.08)
    
    public var areaChartGradientColors: [CGColor] = []
    public var klineMinuteLineColor: UIColor = .red
    public var klineMinuteLineWidth: CGFloat = 1.0
    
    public var showTime: Bool = true
    public var showRightPrice: Bool = true
    
    public var mainYLineNumber: Int = 5
    
    public init() {}
}
