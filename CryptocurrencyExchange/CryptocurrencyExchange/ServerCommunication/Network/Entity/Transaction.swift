//
//  TransactionValue.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/11.
//

import Foundation

// MARK: - TransactionEntity
enum TransactionType: String, Codable {
        case ask = "ask"
        case bid = "bid"
}

struct TransactionData: Codable {
    let transaction_date: String
    let type: TransactionType
    let units_traded: String
    let price: String
    let total: String
}

extension TransactionData {
    func generate() -> TransactionEntity {
        let type = convert(type: type)
        
        return TransactionEntity(
            date: transaction_date,
            type: type,
            price: price,
            quantity: units_traded
        )
    }
    
    private func convert(type: TransactionType) -> WebSocketEachTransaction.BuySellGb {
        return type ==  .bid ? .salesBid : .salesAsk
    }
}
