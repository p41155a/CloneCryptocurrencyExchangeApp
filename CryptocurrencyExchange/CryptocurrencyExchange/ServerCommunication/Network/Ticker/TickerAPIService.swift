//
//  TickerAPIService.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/02.
//

import Foundation

enum TickerAPIService: APIService {
    case ticker(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) // 입출금 현황 정보
}

extension TickerAPIService {
    var path: String {
        switch self {
        case .ticker(let orderCurrency, let paymentCurrency):
            return "/public/ticker/\(orderCurrency.value)_\(paymentCurrency.value)"
        }
    }
    
    var method: Method {
        switch self {
        case .ticker:
            return .get
        }
    }
    
    var request: RequestType {
        switch self {
        case .ticker:
            return .query
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .ticker:
            return [:]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .ticker:
            return nil // ex. ["Content-Type": "application/json"]
        }
    }
}
