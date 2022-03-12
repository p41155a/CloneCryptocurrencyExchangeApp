//
//  SoloTypeSocketControllable.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/12.
//

import Foundation
import Starscream

protocol SoloTypeSocketControllable: CommonSocketAdaptable {
    var parameter: [String: Any] { get }
    func writeToSocket()
}

extension SoloTypeSocketControllable {
    func writeToSocket() {
        let json = try! JSONSerialization.data(withJSONObject: parameter, options: [])
        socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
    }
}

class SoloSocketManager<T: Codable>: SoloTypeSocketControllable {
    var socket: WebSocket?
    var parameter: [String : Any]
    var socketData: Observable<T?> = Observable(nil)
    
    init(parameter: [String: Any]) {
        self.parameter = parameter
        self.connect()
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
            do {
                let data = string.data(using: .utf8)!
                let entity = try JSONDecoder().decode(T.self, from: data)
                socketData.value = entity
            } catch  {
                print("Received text: \(string)\n", error)
            }
        default:
            break
        }
    }
}
