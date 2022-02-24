//
//  APIService.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation

enum APIService {
    case assetsStatus(orderCurrency: String) // 입출금 현황 정보
}

extension APIService {
    
    var scheme: String { return "https" }
    
    var host: String { return "api.bithumb.com" }
    
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

extension APIService {
    enum Method: String {
        case get
        case post
        case put
        case delete
    }

    enum RequestType {
        case json
        case query
    }
}

extension APIService {
    private func setURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        return urlComponents
    }
    
    private func setQuery() -> [URLQueryItem] {
        return parameters.map { key, value in
             URLQueryItem(name: key, value: String(describing: value))
        }
    }
    
    func setURLRequest() -> URLRequest? {
        var URLComponents = setURLComponents()
        let query = setQuery()
        URLComponents.queryItems = query
        
        guard let url: URL = URLComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch method {
        case .post, .put:
            let json = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = json
        default:
            break
        }
        
        headers?.forEach{ (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
