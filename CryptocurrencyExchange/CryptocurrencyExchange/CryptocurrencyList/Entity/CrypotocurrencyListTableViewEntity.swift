//
//  CrypotocurrencyListTableViewEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/03.
//

import Foundation

struct CrypotocurrencyListTableViewEntity {
    let symbol: String              // 가상자산명
    let payment: PaymentCurrency    // BTC / KRW
    let currentPrice: String        // 현재가
    let changeRate: String          // 변동률
    let changeAmount: String        // 변동금액
    let transactionAmount: String   // 거래금액
}
