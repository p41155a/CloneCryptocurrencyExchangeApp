//
//  TransactionDescriptionEntity.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import Foundation

struct TradeDescriptionEntity {
    var volume: String              // 당일 거래량 (24H)
    var value: String               // 당일 총 거래금 (24H)
    var prevClosingPrice: String      // 전일 종가 (24H)
    var openingPrice: String           // 시가 (24H)
    var maxPrice: String           // 고가 (24H)
    var minPrice: String            // 저가 (24H)
    var symbol: String
}
