//
//  KlineTypeCommon.swift
//  Kline
//
//  Created by zhangj on 2020/8/1.
//

import Foundation

struct KlineTypeCommon {
    /// index: ChartView - kLine's index
    static func lineType(for chartType: ChartType, index: Int) -> Int {
        switch chartType {
        case .main_ma:
            return index == 0 ? 0 : 1
        case .main_boll:
            if index == 0 {
                return 0
            }
            return index + 2
        case .volume:
            if index > 0 {
                return 2
            }
            return 14
        case .assistant_macd:
            if index == 0 {
                return 8
            } else if index == 1 {
                return 6
            } else {
                return 7
            }
        case .assistant_kdj:
            if index == 2 {
                return 11
            }
            if index == 1 {
                return 10
            } else {
                return 9
            }
        case .assistant_rsi:
            return 12
        case .assistant_wr:
            return 13
        case .main:
            return 0
        default:
            return 0
        }
    }
    
    static func lineColor(for chartType: ChartType, index: Int) -> UIColor {
        switch chartType {
        case .main_ma, .main_boll:
            switch index {
            case 1:
                return ColorManager.shared.klineMA1Color
            case 2:
                return ColorManager.shared.klineMA2Color
            case 3:
                return ColorManager.shared.klineMA3Color
            case 4:
                return ColorManager.shared.klineMA4Color
            case 5:
                return ColorManager.shared.klineMA5Color
            case 6:
                return ColorManager.shared.klineMA6Color
            default:
                return ColorManager.shared.klineMA1Color
            }
        case .volume:
            switch index {
            case 0:
                return ColorManager.shared.klineMA6Color
            case 1:
                return ColorManager.shared.klineMA1Color
            case 2:
                return ColorManager.shared.klineMA2Color
            default:
                return ColorManager.shared.klineMA1Color
            }
        case .assistant_kdj, .assistant_rsi, .assistant_wr:
            switch index {
            case 0:
                return ColorManager.shared.klineMA1Color
            case 1:
                return ColorManager.shared.klineMA2Color
            case 3:
                return ColorManager.shared.klineMA3Color
            default:
                return ColorManager.shared.klineMA1Color
            }
        case .assistant_macd:
            switch index {
            case 0:
                return ColorManager.shared.klineMA6Color
            case 1:
                return ColorManager.shared.klineMA1Color
            case 2:
                return ColorManager.shared.klineMA2Color
            default:
                return ColorManager.shared.klineMA1Color
            }
        default:
            return ColorManager.shared.klineMA1Color
        }
    }
}
