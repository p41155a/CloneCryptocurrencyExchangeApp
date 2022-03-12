//
//  TickerWebSocketManager.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/12.
//

import Foundation
import Starscream

class TickerWebSocketManager {
    private var socket: WebSocket?
    var symbols: String
    var tickerData: Observable<WebSocketTickerContent?>
    
    init(symbols: String) {
        self.symbols = symbols
        self.tickerData = Observable(nil)
    }

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
    
    private func writeToSocket() {
        let params: [String: Any] = [
            "type": WebSocketType.ticker.rawValue,
            "symbols": self.symbols,
            "tickTypes": WebSocketTickType.tick24H.rawValue
        ]
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: [])
            socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
        } catch {
            print("소켓 요청에 실패")
//            showAlert(title: "소켓 요청에 실패하였습니다. 관리자에게 문의해주세요", completion: nil)
        }
    }

}

// MARK: - Delegate WebSocket
extension TickerWebSocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            writeToSocket()
        case .text(let string):
            do {
                let data = string.data(using: .utf8)!
                let json = try JSONDecoder().decode(WebSocketTickerEntity.self, from: data)
                let tickerInfo: WebSocketTickerContent = json.content
                self.tickerData.value = tickerInfo
            } catch  {
                print("Received text: \(error)")
            }
        default:
            break
        }
    }
}
