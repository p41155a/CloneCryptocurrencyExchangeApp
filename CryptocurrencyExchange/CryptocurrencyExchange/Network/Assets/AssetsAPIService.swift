//
//  AssetsAPIService.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/28.
//

import Foundation

enum AssetsAPIService: APIService {
    case assetsStatus(orderCurrency: String) // 입출금 현황 정보
}

extension AssetsAPIService {
    var path: String {
        switch self {
        case .assetsStatus(let orderCurrency):
            return "/public/assetsstatus/\(orderCurrency)"
        }
    }
    
    var method: Method {
        switch self {
        case .assetsStatus:
            return .get
        }
    }
    
    var request: RequestType {
        switch self {
        case .assetsStatus:
            return .query
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .assetsStatus:
            return [:]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .assetsStatus:
            return nil // ex. ["Content-Type": "application/json"]
        }
    }
}
