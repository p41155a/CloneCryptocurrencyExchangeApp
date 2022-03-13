//
//  OrderbookViewModelWebsocket+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/12.
//

import Foundation

extension OrderbookViewModel {
    func set(from data: String) {
        self.approach(for: data)
    }
    
    fileprivate func approach(for data: String) {
        guard let data = data.data(using: .utf8) as? Data,
              let json = Decoded<WebSocketOrderbookEntity>(data: data),
              let value = json.value else {
                  return
              }
        setWebSocketOrderbookData(with: value)
    }
}

extension OrderbookViewModel {
    private func setWebSocketOrderbookData(
        with data: WebSocketOrderbookEntity,
        at index: Int = Int.zero
    ) {
        let webSocketAskOrderbooks = data.content.asks.map {
            $0.generate()
        }
        
        orderbookManager.updateOrderbook(
            orderbooks: webSocketAskOrderbooks,
            to: &askOrderbooksList.value,
            type: .ask)
        
        let webSocketBidOrderbooks = data.content.bids.map {
            $0.generate()
        }
        
        orderbookManager.updateOrderbook(
            orderbooks: webSocketBidOrderbooks,
            to: &bidOrderbooksList.value,
            type: .bid
        )
    }
}
