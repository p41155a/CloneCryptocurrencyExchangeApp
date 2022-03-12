//
//  TransactionInforamtion.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import Foundation

struct TransactionInforamtion {
    let saleType: WebSocketEachTransaction.BuySellGb
    let date: String
    let price: String
    let amount: String
}
