//
//  APIError.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation

enum APIError: Error {
    case bithumbDefinedError(error: ErrorEnity)
    case invalidURL
    case incorrectFormat
    case failureResponse(error: Error)
}
extension APIError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .bithumbDefinedError(error):
            return "\(error.message)"
        case .invalidURL:
            return "유효하지 않은 url 입니다."
        case .incorrectFormat:
            return "정의되지 않은 데이터 형식입니다."
        case let .failureResponse(error):
            return "\(error.localizedDescription)"
        }
    }
}
