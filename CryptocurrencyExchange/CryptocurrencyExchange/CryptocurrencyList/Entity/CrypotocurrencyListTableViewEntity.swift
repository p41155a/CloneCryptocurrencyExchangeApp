//
//  CrypotocurrencyListTableViewEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/03.
//

import Foundation

struct CrypotocurrencyKRWListTableViewEntity {
    let symbol: String              // 가상자산명
    let payment: PaymentCurrency    // BTC / KRW
    let currentPrice: String        // 현재가
    let changeRate: String          // 변동률
    let changeAmount: String        // 변동금액
    let transactionAmount: String   // 거래금액
    
    init(symbol: String = "",
         payment: PaymentCurrency = .KRW,
         currentPrice: String = "",
         changeRate: String = "",
         changeAmount: String = "",
         transactionAmount: String = "") {
        self.symbol = symbol
        self.payment = payment
        self.currentPrice = currentPrice
        self.changeRate = changeRate
        self.changeAmount = changeAmount
        self.transactionAmount = transactionAmount
    }
}

struct CrypotocurrencyBTCListTableViewEntity {
    let symbol: String              // 가상자산명
    let payment: PaymentCurrency    // BTC / KRW
    let currentPrice: String        // 현재가
    let changeRate: String          // 변동률
    let transactionAmount: String   // 거래금액
}
