//
//  KlineModel.swift
//  Kline_Example
//
//  Created by zhangj on 2020/7/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ObjectMapper

struct KlineTick: Mappable {
    var open: NSDecimalNumber = 0.0
    var close: NSDecimalNumber = 0.0
    var low: NSDecimalNumber = 0.0
    var high: NSDecimalNumber = 0.0
    var amount: NSDecimalNumber = 0.0
    var time: Int = 0
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        close <- (map["close"], NSDecimalNumberTransform())
        open <- (map["open"], NSDecimalNumberTransform())
        low <- (map["low"], NSDecimalNumberTransform())
        high <- (map["high"], NSDecimalNumberTransform())
        amount <- (map["amount"], NSDecimalNumberTransform())
        time <- map["id"]
    }
    
    
}
