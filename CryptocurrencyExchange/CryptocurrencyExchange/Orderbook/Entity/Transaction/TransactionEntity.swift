//
//  TransactionEntity.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/09.
//

import Foundation

struct TransactionEntity {
    // MARK: - Property
    var date: String
    var type: WebSocketEachTransaction.BuySellGb
    var price: String
    var quantity: String
}

extension TransactionEntity {
    var commaPrice: String {
        return price.setNumStringForm() ?? ""
    }
    
    var roundedQuantity: String {
        return quantity.roundedQuantity() ?? ""
    }
}
