//
//  TransactionAPIService.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/12.
//

import Foundation

enum TransactionAPIService: APIService {
    case list(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency)
}

extension TransactionAPIService {
    var path: String {
        switch self {
        case .list(let orderCurrency, let paymentCurrency):
            return "/public/transaction_history/\(orderCurrency.value)_\(paymentCurrency.value)"
        }
    }
    
    var method: Method {
        switch self {
        case .list:
            return .get
        }
    }
    
    var request: RequestType {
        switch self {
        case .list:
            return .query
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .list:
            return [:]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .list:
            return nil
        }
    }
}
