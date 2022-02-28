//
//  APIService.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation

protocol APIService {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: Method { get }
    var request: RequestType { get }
    var parameters: [String: Any] { get }
    var headers: [String: String]? { get }
}
extension APIService {
    var scheme: String { return "https" }
    var host: String { return "api.bithumb.com" }
}

extension APIService {
    private func setURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        switch method {
        case .get:
            let query = setQuery()
            urlComponents.queryItems = query
        default:
            break
        }
        return urlComponents
    }
    
    private func setQuery() -> [URLQueryItem] {
        return parameters.map { key, value in
             URLQueryItem(name: key, value: String(describing: value))
        }
    }
    
    func setRequest() -> URLRequest? {
        let urlComponents = setURLComponents()
        guard let url: URL = urlComponents.url else { return nil }
    
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
