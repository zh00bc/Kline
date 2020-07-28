//
//  HBKlineDateCommon.swift
//  kline
//
//  Created by zhang j on 2019/8/12.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation

struct KlineDateCommon {
    static let formatter = DateFormatter()
    
    static func string(timestamp: Int, period: PeriodType) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        switch period {
        case .timeline:
            formatter.dateFormat = "HH:mm"
        case .day, .week:
            formatter.dateFormat = "yyyy-MM-dd"
        case .month:
            formatter.dateFormat = "yyyy-MM-dd"
        case .min, .min15, .min30, .hour, .hour4:
            formatter.dateFormat = "MM-dd HH:mm"
        default:
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
        }
        let string = formatter.string(from: date)
        return string
    }
}

//+ (id)strDate:(long long)arg1 period:(long long)arg2;
//+ (id)stringYYYYmdFromTime:(long long)arg1;
//+ (id)stringYmdFromTime:(long long)arg1;
//+ (id)stringMdHmFromTime:(long long)arg1;
//+ (id)stringHmFromTime:(long long)arg1;
//+ (id)stringYmFromTime:(long long)arg1;
//+ (id)stringMdFromTime:(long long)arg1;
//+ (id)stringYmdHmFromTime:(long long)arg1;
