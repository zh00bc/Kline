//
//  HuobiSocket.swift
//  kline
//
//  Created by zhang j on 2019/11/27.
//  Copyright © 2019 zhangj. All rights reserved.
//

import Foundation
import Starscream
import Gzip
import RxSwift

public protocol HuobiSocketDelegate: class {
    func huobiSocketDidConnected(_ huobiSocket: HuobiSocket)
    func huobiSocket(_ huobiSocket: HuobiSocket, didDisConnectError error: Error?)
    func huobiSocket(_ huobiSocket: HuobiSocket, didReceiveData data: Data)
}

open class HuobiSocket: NSObject {
    
    fileprivate let HOST_URLSTRING = "wss://api.hadax.com/ws"
    
    fileprivate var webSocket: WebSocket?
    
    public weak var delegate: HuobiSocketDelegate?
    
    public func connect() {
        let request = URLRequest(url: URL(string: HOST_URLSTRING)!)
        let socket = WebSocket(request: request)
        self.webSocket = socket
        socket.delegate = self
        socket.connect()
    }
    
    public func subscribe(_ topic: String) {
        let sub = Subscribe(sub: topic, id: generateID())
        sendMessage(sub)
    }
    
    public func unSubscribe(_ topic: String) {
        let unsub = UnSubscribe(unsub: topic, id: generateID())
        sendMessage(unsub)
    }
    
    public func request(_ request: String) {
        let req = Request(req: request, id: generateID())
        sendMessage(req)
    }
    
    fileprivate func sendMessage<T: Codable>(_ message: T) {
        if let encode = try? JSONEncoder().encode(message),
            let json = String(data: encode, encoding: .utf8) {
            self.webSocket?.write(string: json)
        } else {
            print("subscribe error......")
        }
    }
    
    fileprivate func generateID() -> String {
        let time = Int64((Date().timeIntervalSince1970 * 1000).rounded())
        return String(time)
    }
    
    struct Subscribe: Codable {
        let sub: String
        let id: String
    }
    
    struct UnSubscribe: Codable {
        let unsub: String
        let id: String
    }
    
    struct Request: Codable {
        let req: String
        let id: String
//        let from: Int
//        let to: Int
    }
}

extension HuobiSocket: WebSocketDelegate {
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected:
            debugPrint(event)
            delegate?.huobiSocketDidConnected(self)
        case let .binary(data):
            var receivedData = data
            
            if data.isGzipped,
                let decompressedData = try? data.gunzipped(),
                let content = String(data: decompressedData, encoding: .utf8) {
                if content.hasPrefix("{\"ping") {
                    let msg = content.replacingOccurrences(of: "ping", with: "pong")
                    self.webSocket?.write(string: msg)
                    return;
                }
                receivedData = decompressedData
            }

            self.delegate?.huobiSocket(self, didReceiveData: receivedData)
        case let .error(err):
            print(err.debugDescription)
        default:
            break
        }
    }
}
