//
//  TransactionValue.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/11.
//

import Foundation

struct TransactionValue: Codable {
    let status: String
    let data: [TransactionData]
}

struct TransactionData: Codable {
    let transaction_date: String
    let type: WebSocketEachTransaction.BuySellGb
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
    
    private func convert(type: WebSocketEachTransaction.BuySellGb) -> WebSocketEachTransaction.BuySellGb {
        return type == .salesBid ? .salesBid : .salesAsk
    }
}
