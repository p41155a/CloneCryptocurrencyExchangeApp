//
//  SeveralTypeSocketControllable.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/12.
//

import Foundation
import Starscream

protocol SeveralTypeSocketControllable: CommonSocketAdaptable {
    var parameters: [[String: Any]] { get }
    func writeToSocket()
}

extension SeveralTypeSocketControllable {
    func writeToSocket() {
        self.parameters.forEach { parameter in
            let json = try! JSONSerialization.data(withJSONObject: parameter, options: [])
            socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
        }
    }
}

class SeveralSocketManager: SeveralTypeSocketControllable {
    var socket: WebSocket?
    
    var parameters: [[String : Any]]
    var socketData: Observable<Data?> = Observable(nil)
    
    init(parameter: [[String: Any]]) {
        self.parameters = parameter
    }
    
    func connect() {
        let url = "wss://pubwss.bithumb.com/pub/ws"
        
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
        socket?.delegate = nil
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            writeToSocket()
            break
        case .text(let string):
            let dataFromString = string.data(using: .utf8)!
            self.socketData.value = dataFromString
        default:
            break
        }
    }
    
}
