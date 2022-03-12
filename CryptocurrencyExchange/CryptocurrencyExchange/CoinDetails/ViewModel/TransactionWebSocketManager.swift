//
//  TransactionWebSocketManager.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import Foundation
import Starscream

class TransactionWebSocketManager {
    private var socket: WebSocket?
    private var paymentCurrency: String
    private var orderCurrency: String
    var transactionData: Observable<WebSocketTransactionEntity?>
    
    init(
        paymentCurrency: String,
        orderCurrency: String
    ) {
        self.paymentCurrency = paymentCurrency
        self.orderCurrency = orderCurrency
        self.transactionData = Observable(nil)
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
    
}

extension TransactionWebSocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            writeToSocket()
            break
        case .text(let string):
            do {
                let data = string.data(using: .utf8)!
                let entity = try JSONDecoder().decode(WebSocketTransactionEntity.self, from: data)
                transactionData.value = entity
            } catch  {
                print("Received text: \(string)\n", error)
            }
        default:
            break
        }
    }
    
    private func writeToSocket() {
        let params: [String: Any] = [
            "type": "transaction",
            "symbols": ["\(orderCurrency)_\(paymentCurrency)"]
        ]
        let json = try! JSONSerialization.data(withJSONObject: params, options: [])
        socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
    }
}
