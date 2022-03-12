//
//  OrderbookValue.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/10.
//

import Foundation

struct OrderBook: Codable {
    let status: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let timestamp: String
    let orderCurrency, paymentCurrency: String
    let bids, asks: [Ask]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case orderCurrency = "order_currency"
        case paymentCurrency = "payment_currency"
        case bids, asks
    }
}

// MARK: - Ask
struct Ask: Codable {
    let quantity, price: String
    
    func generate(type: WebSocketEachOrderbook.OrderType) -> OrderbookEntity {
        return OrderbookEntity(
            price: price,
            quantity: quantity,
            type: type
        )
    }
}
