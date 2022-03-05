//
//  TransactionDescriptionEntity.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import Foundation

struct TransactionDescriptionEntity {
    let volume: String              // 당일 거래량 (24H)
    let value: String               // 당일 총 거래금 (24H)
    let prevClosePrice: String      // 전일 종가 (24H)
    let openPrice: String           // 시가 (24H)
    let highPrice: String           // 고가 (24H)
    let lowPrice: String            // 저가 (24H)
}
