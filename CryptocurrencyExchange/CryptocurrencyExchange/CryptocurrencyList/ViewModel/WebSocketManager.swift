//
//  WebSocketManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/12.
//

import Foundation
import Starscream

protocol AllTickerWebSocketManagerDelegate: AnyObject {
    func handingError(for error: String)
    func setWebSocketData(with entity: WebSocketTickerEntity)
}
final class AllTickerWebSocketManager {
    private var socket: WebSocket?
    var symbolsKRW: [String] = []
    var symbolsBTC: [String] = []
    weak var delegate: AllTickerWebSocketManagerDelegate?
    
    // MARK: - func<websocket>
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
    
    func writeToSocket() {
        let symbols: [String] = symbolsKRW + symbolsBTC
        let params: [String: Any] = [
            "type": "ticker",
            "symbols": symbols,
            "tickTypes": [WebSocketTickType.tick24H.rawValue]
        ]
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: [])
            socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
        } catch {
            delegate?.handingError(for: "소켓 요청에 실패하였습니다. 관리자에게 문의해주세요")
        }
    }
}
// MARK: - Delegate WebSocket
extension AllTickerWebSocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            writeToSocket()
        case .text(let string):
            do {
                let data = string.data(using: .utf8)!
                let entity = try JSONDecoder().decode(WebSocketTickerEntity.self, from: data)
                delegate?.setWebSocketData(with: entity)
            } catch  {
                print("Received text: \(string)")
            }
        default:
            break
        }
    }
}
