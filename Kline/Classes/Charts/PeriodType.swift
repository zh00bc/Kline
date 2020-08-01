//
//  PeriodType.swift
//  kline
//
//  Created by zhangj on 2020/7/26.
//  Copyright © 2020 zhangj. All rights reserved.
//

import Foundation

//public enum PeriodType: Int {
//    case min15 = 0
//    case timeline = 1
//    case min = 2
//    case min5 = 3
//    case min30 = 4
//    case hour = 5
//    case hour4 = 6
//    case day = 7
//    case week = 8
//    case month = 9
//}

public enum PeriodType {
    case min15
    case timeline
    case min
    case min5
    case min30
    case hour
    case hour4
    case day
    case week
    case month
    
    public var string: String {
        switch self {
        case .min15:
            return "15min"
        case .timeline:
            return "1min"
        case .min5:
            return "5min"
        case .min30:
            return "30min"
        case .hour:
            return "1hour"
        case .hour4:
            return "4hour"
        case .day:
            return "1day"
        case .week:
            return "1week"
        case .month:
            return "1mon"
        case .min:
            return "1min"
        }
    }
}
