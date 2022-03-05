//
//  CandleStickAPIService.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import Foundation

enum CandleStickAPIService: APIService {
    // 시간 및 구간 별 빗썸 거래소 가상자산 가격, 거래량 정보를 제공
    case candleStick(candleStickParameters: CandleStickParameters)
}

extension CandleStickAPIService {
    var path: String {
        switch self {
        case .candleStick(let parameters):
            return "/public/candlestick/\(parameters.path())"
        }
    }
    
    var method: Method {
        switch self {
        case .candleStick:
            return .get
        }
    }
    
    var request: RequestType {
        switch self {
        case .candleStick:
            return .query
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .candleStick:
            return [:]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .candleStick:
            return nil // ex. ["Content-Type": "application/json"]
        }
    }
}
