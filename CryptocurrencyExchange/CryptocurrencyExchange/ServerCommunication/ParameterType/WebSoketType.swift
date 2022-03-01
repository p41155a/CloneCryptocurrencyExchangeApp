//
//  WebSoketType.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/26.
//

import Foundation

enum WebSocketType: String, Codable {
    case ticker = "ticker" // 증권 시세 표시기
    case transaction = "transaction" // 거래 체결 완료 내역
    case orderbookdepth = "orderbookdepth" // 호가
}
