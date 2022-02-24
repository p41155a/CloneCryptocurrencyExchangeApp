//
//  APIError.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case deserializationError(error: Swift.Error)
}
extension APIError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 url 입니다."
        case let .deserializationError(error):
            return "Error during deserialization of the response: \(error)"
        }
    }
}
