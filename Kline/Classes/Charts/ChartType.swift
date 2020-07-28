//
//  ChartType.swift
//  kline
//
//  Created by zhang j on 2019/6/14.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation

/// 包括指标

public enum ChartType: Int {
    /// 主图ma
    case main_ma = 0
    
    /// 主图boll
    case main_boll = 1
    
    /// 交易量
    case volume = 2
    
    /// 副图macd
    case assistant_macd = 3
    
    /// 副图kdj
    case assistant_kdj = 4
    
    /// 副图rsi
    case assistant_rsi = 5
    
    /// 副图wr
    case assistant_wr = 6
    
    /// 主图无指标
    case main = 7
    
    /// 副图隐藏
    case assistant_hide = 8
}
