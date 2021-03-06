//
//  CryptocurrencyListTableViewEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/03.
//

import Foundation

struct CryptocurrencyListTableViewEntity {
    let order: String               // 가상자산명
    let payment: PaymentCurrency    // BTC / KRW
    let currentPrice: Double        // 현재가
    let changeRate: Double          // 변동률
    let changeAmount: String        // 변동금액
    let transactionAmount: Double   // 거래금액
    let volumePower: String         // 체결강도
    
    init(order: String = "",
         payment: PaymentCurrency = .KRW,
         currentPrice: Double = 0,
         changeRate: Double = 0,
         changeAmount: String = "",
         transactionAmount: Double = 0,
         volumePower: String = "") {
        self.order = order
        self.payment = payment
        self.currentPrice = currentPrice
        self.changeRate = changeRate
        self.changeAmount = changeAmount
        self.transactionAmount = transactionAmount
        self.volumePower = volumePower
    }
}
