//
//  OrderBookEntity.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import Foundation

struct OrderbookEntity: Hashable {
    var price: String
    var quantity: String
    var type: WebSocketEachOrderbook.OrderType
}

extension OrderbookEntity {
    var commaPrice: String {
        return price.setNumStringForm(isDecimalType: true) ?? ""
    }
    
    var roundedQuantity: String {
        return quantity.roundedQuantity() ?? ""
    }
}
