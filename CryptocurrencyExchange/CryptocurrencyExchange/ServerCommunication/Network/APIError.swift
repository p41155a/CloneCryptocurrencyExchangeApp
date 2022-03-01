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

// 테스트를 위해 Equatable을 구현
extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.bithumbDefinedError, .bithumbDefinedError):
            return true
        case (.invalidURL, .invalidURL):
            return true
        case (.incorrectFormat, .incorrectFormat):
            return true
        case (.failureResponse, .failureResponse):
            return true
        default:
            return false
        }
    }
}
