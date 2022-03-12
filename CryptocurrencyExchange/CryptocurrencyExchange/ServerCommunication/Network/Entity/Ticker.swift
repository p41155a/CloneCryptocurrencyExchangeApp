//
//  Ticker.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/12.
//

import Foundation

/// AssetsStatus
struct Ticker: Codable {
    let status: String
    let data: TickerInfo
}

/// EachAccountStatus
struct TickerInfo: Codable {
    let openingPrice: String
    let closingPrice: String
    let minPrice: String
    let maxPrice: String
    let unitsTraded: String
    let accTradeValue: String
    let prevClosingPrice: String
    let unitsTraded24H: String
    let accTradeValue24H: String
    let fluctate24H: String
    let fluctateRate24H: String
    let date: String
}

extension TickerInfo {
    enum CodingKeys: String, CodingKey {
        case openingPrice = "opening_price"
        case closingPrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case unitsTraded = "units_traded"
        case accTradeValue = "acc_trade_value"
        case prevClosingPrice = "prev_closing_price"
        case unitsTraded24H = "units_traded_24H"
        case accTradeValue24H = "acc_trade_value_24H"
        case fluctate24H = "fluctate_24H"
        case fluctateRate24H = "fluctate_rate_24H"
        case date = "date"
    }
}

extension TickerInfo {
    func generate(currencyName: String) -> TradeDescriptionEntity {
        return TradeDescriptionEntity(
            volume: accTradeValue24H ?? "",
            value: unitsTraded24H ?? "",
            prevClosingPrice: prevClosingPrice ?? "",
            openingPrice: openingPrice ?? "",
            maxPrice: maxPrice ?? "",
            minPrice: minPrice ?? "",
            symbol: currencyName ?? ""
        )
    }
}
