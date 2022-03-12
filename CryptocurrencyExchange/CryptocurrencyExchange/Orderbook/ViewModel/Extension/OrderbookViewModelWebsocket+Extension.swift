//
//  OrderbookViewModelWebsocket+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/12.
//

import Foundation

extension OrderbookViewModel {
    func set(from data: String) {
        self.checkWebSocketType(for: data)
    }
    
    fileprivate func checkWebSocketType(for data: String) {
        guard let data = data.data(using: .utf8) as? Data,
              let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                  return
              }
        
        if let webSocketType = json["type"] as? String{
            self.approach(to: data, of: WebSocketType(rawValue: webSocketType)?.rawValue ?? "")
        }
    }
    
    /// WebSocket Type별로 접근.
    private func approach(to data: Data, of type: String) {
        switch type {
        case "ticker" :
            guard let json = Decoded<WebSocketTickerEntity>(data: data),
                  let value = json.value else {
                      return
                  }
            
            setWebSocketTickerData(with: value)
        case "orderbookdepth":
            guard let json = Decoded<WebSocketOrderbookEntity>(data: data),
                  let value = json.value else {
                      return
                  }
            
            setWebSocketOrderbookData(with: value)
        case "transaction":
            guard let json = Decoded<WebSocketTransactionEntity>(data: data),
                  let value = json.value else {
                      return
                  }
            
            setWebSocketTransactionData(with: value)
        default:
            break
        }
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

//MARK: WebSocket
extension OrderbookViewModel {
    private func setWebSocketTransactionData(
        with data: WebSocketTransactionEntity,
        at index: Int = Int.zero
    ) {
        let transactionInfo = data.content.list.map {
            $0.generate()
        }.reversed()
        
        transactionList.value.insert(contentsOf: transactionInfo, at: index)
    }
}

extension OrderbookViewModel {
    private func setWebSocketTickerData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        
        fasteningStrengthList.value = tickerInfo.volumePower
        closedPrice.value = tickerInfo.closePrice
        
        tradeDescriptionList.value.append(setTradeDescriptionData(
            volume: tickerInfo.volume,
            value: tickerInfo.value,
            prevClosingPrice: tickerInfo.prevClosePrice,
            openingPrice: tickerInfo.openPrice,
            maxPrice: tickerInfo.highPrice,
            minPrice: tickerInfo.lowPrice,
            symbol: tickerInfo.symbol
        ))
    }
    
    // MARK:  Trade Description
    private func setTradeDescriptionData(
        volume: String,
        value: String,
        prevClosingPrice: String,
        openingPrice: String,
        maxPrice: String,
        minPrice: String,
        symbol: String
    ) -> TradeDescriptionEntity {
        return TradeDescriptionEntity(
            volume: volume,
            value: value,
            prevClosingPrice: prevClosingPrice,
            openingPrice: openingPrice,
            maxPrice: maxPrice,
            minPrice: minPrice,
            symbol: symbol
        )
    }
}
