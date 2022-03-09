//
//  WebSocketOrderbookEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/26.
//

import Foundation

struct WebSocketOrderbookEntity: Codable {
    let type: WebSocketType
    let content: WebSocketOrderbookContent
}

struct WebSocketOrderbookContent: Codable {
    let list: [WebSocketEachOrderbook]
}

struct WebSocketEachOrderbook: Codable {
    let symbol: String          // 통화코드
    let orderType: orderType    // 주문타입 – bid(매수) / ask(매도)
    let price: String           // 호가
    let quantity: String        // 잔량
    let total: String           // 건수
}

extension WebSocketEachOrderbook {
    enum orderType: String, Codable {
        case ask = "ask"
        case bid = "bid"
    }
}
