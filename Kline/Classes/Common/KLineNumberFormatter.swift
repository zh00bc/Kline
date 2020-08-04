//
//  KLineUtilCommon.swift
//  kline
//
//  Created by zhang j on 2019/8/15.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation

struct KLineNumberFormatter {
    static let formatter: NumberFormatter = NumberFormatter()

    static func format(volume: NSNumber, amountPrecision: Int) -> String {
        switch volume.doubleValue {
        case 1000000.0...:
            return String(format: "%.0fM", volume.doubleValue / 1000000.0)
        case 100000.0...:
            return String(format: "%.0fK", volume.doubleValue / 1000.0)
        case 10000.0...:
            return String(format: "%.1fK", volume.doubleValue / 1000.0)
        default:
            formatter.maximumFractionDigits = amountPrecision
            formatter.minimumFractionDigits = amountPrecision
            formatter.roundingMode = .down
            return formatter.string(from: volume) ?? ""
        }
    }
    
    static func format(_ number: NSNumber, precision: Int, numberStyle: NumberFormatter.Style = .none, roundingMode: NumberFormatter.RoundingMode = .down, positivePrefix: Bool = false) -> String {
        formatter.numberStyle = numberStyle
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = precision
        formatter.roundingMode = roundingMode
        if positivePrefix {
            formatter.positivePrefix = "+"
        } else {
            formatter.positivePrefix = ""
        }
        return formatter.string(from: number) ?? ""
    }
    
    static func format(_ number: Double, precision: Int, numberStyle: NumberFormatter.Style = .none, roundingMode: NumberFormatter.RoundingMode = .down, positivePrefix: Bool = false) -> String {
        return format(NSNumber(value: number), precision: precision, numberStyle: numberStyle, roundingMode: roundingMode, positivePrefix: positivePrefix)
    }
}



//+ (id)formatString:(id)arg1 precision:(long long)arg2;
//+ (id)formatDouble:(double)arg1 precision:(long long)arg2;
//+ (id)formatNumber:(id)arg1 precision:(long long)arg2;
//+ (id)formatNumber:(id)arg1 precision:(long long)arg2 roundingMode:(unsigned long long)arg3;
//+ (id)formatNumber:(id)arg1 precision:(long long)arg2 numberStyle:(unsigned long long)arg3 roundingMode:(unsigned long long)arg4;
