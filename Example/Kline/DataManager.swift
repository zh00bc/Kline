//
//  MarketDataManager.swift
//  kline
//
//  Created by zhangj on 2019/8/11.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation
import ObjectMapper
import Kline

protocol MarketDataManagerDelegate {
    func update(kline: PeriodType, resetHistory: Bool)
}

class MarketDataSource: KlineViewDataSource {

    var socket: HuobiSocket?

    deinit {
        print("MarketDataManager deinit")
    }
    
    override init() {
        super.init()
        socket = HuobiSocket()
        socket?.delegate = self
        socket?.connect()
    }
}

extension MarketDataSource: HuobiSocketDelegate {
    func watch(symbol: String, period: String) {
        let topic = "market.\(symbol).kline.\(period)"
        socket?.subscribe(topic)
    }
    
    func unWatch(symbol: String, period: String) {
        let topic = "market.\(symbol).kline.\(period)"
        socket?.unSubscribe(topic)
    }
    
    func unWatch(topic: String) {
        socket?.unSubscribe(topic)
    }
    
    func request(symbol: String, period: String) {
        let req = "market.\(symbol).kline.\(period)"
        socket?.request(req)
    }
    
    func huobiSocketDidConnected(_ huobiSocket: HuobiSocket) {
//        request(symbol: "btcusdt", period: "1min")
//        watch(symbol: "btcusdt", period: "1min")
    }
    
    func huobiSocket(_ huobiSocket: HuobiSocket, didDisConnectError error: Error?) {
        if let error = error {
            print("error:\(error.localizedDescription)")
        }
    }
    
    func huobiSocket(_ huobiSocket: HuobiSocket, didReceiveData data: Data) {
        guard let content = String(data: data, encoding: .utf8) else {
            print("can not read receiveData")
            return
        }
    
        // 如果收到的是订阅成功的消息，不解析
        if content.contains("subbed") {
            return
        }
        // 否则用K线解析
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: AnyObject]
            
            var isSub = false
            var deleteHistory = false
            if content.contains("rep") {
                isSub = false
                deleteHistory = true
                
            } else {
                isSub = true
                deleteHistory = false
            }
            
            var klines: [KlineTick] = []
            if let tick = dict["tick"] as? [String: Any] {
                if let k = Mapper<KlineTick>().map(JSON: tick) {
                    klines = [k]
                }
            } else if let datas = dict["data"] as? [[String: Any]] {
                klines = Mapper<KlineTick>().mapArray(JSONArray: datas)
            }
            
            if let ch = dict["ch"] as? String {
                if !ch.contains(period.string) {
                    return
                }
            }
            
            let lines = klines.map { (tick) -> KLineDataModel in
                let kline = KLineDataModel()
                kline.open = tick.open
                kline.close = tick.close
                kline.high = tick.high
                kline.low = tick.low
                kline.amount = tick.amount
                kline.change = tick.close.subtracting(tick.open)
                kline.changeRate = kline.change.dividing(by: kline.open.multiplying(by: 100))
                kline.time = tick.time
                return kline
            }
            
            append(klines: lines, period: period, bSub: isSub, deleteHistory: deleteHistory)
            
        } catch(let err) {
            print(content)
            print(err.localizedDescription)
        }
    }
}
