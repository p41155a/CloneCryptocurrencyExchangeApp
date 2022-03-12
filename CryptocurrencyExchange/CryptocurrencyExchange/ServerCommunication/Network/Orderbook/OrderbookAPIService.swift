//
//  OrderbookAPIService.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/11.
//
import Foundation

enum OrderbookAPIService: APIService {
    case order(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) // 입출금 현황 정보
}

extension OrderbookAPIService {
    var path: String {
        switch self {
        case .order(let orderCurrency, let paymentCurrency):
            return "/public/orderbook/\(orderCurrency.value)_\(paymentCurrency.value)"
        }
    }
    
    var method: Method {
        switch self {
        case .order:
            return .get
        }
    }
    
    var request: RequestType {
        switch self {
        case .order:
            return .query
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .order:
            return [:]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .order:
            return nil
        }
    }
}
