//
//  TickType.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/26.
//

import Foundation

enum WebSocketTickType: String {
    case tick30M = "30M"
    case tick1H = "1H"
    case tick12H = "12H"
    case tick24H = "24H"
    case tickMID = "MID"
}
