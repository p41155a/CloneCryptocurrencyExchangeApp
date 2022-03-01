//
//  WebSocketTransactionEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/26.
//

import Foundation

struct WebSocketTransactionEntity: Codable {
    let type: WebSocketType
    let content: WebSocketOrderbookContent
}

struct WebSocketTransactionContent: Codable {
    let list: [WebSocketEachTransaction]
}

struct WebSocketEachTransaction: Codable {
    let symbol: String          // 통화코드
    let buySellGb: BuySellGb    // 체결종류(1:매도체결, 2:매수체결)
    let contPrice: String       // 체결가격
    let contQty: String         // 체결수량
    let contAmt: String         // 체결금액
    let contDtm: String         // 체결시각
    let updn: UpDown            // 직전 시세와 비교 : up-상승, dn-하락
    
    enum BuySellGb: String, Codable {
        case salesAsk = "1"
        case salesBid = "2"
    }
    
    enum UpDown: String, Codable {
        case up = "up"
        case down = "dn"
    }
}
