//
//  ZHChartIndex.swift
//  kline
//
//  Created by zhangj on 2019/5/29.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

enum ChartIndex {
    case MA(D: Int)
    case BOLL(N: Int, P: Int)
    case MACD(S: Int, L: Int, M: Int)
    case KDJ(N: Int, M1: Int, M2: Int)
    case RSI(D: Int)
    case WR(D: Int)
    case None
}
