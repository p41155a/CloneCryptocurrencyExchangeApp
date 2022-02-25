//
//  APIManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation
import Alamofire

protocol APIManager {
    func apiRequest<T: Codable>(request: URLRequestConvertible ,type: T.Type, completion: @escaping (Result<T, APIError>) -> ())
}
extension APIManager {
    func apiRequest<T: Codable>(request: URLRequestConvertible ,type: T.Type, completion: @escaping (Result<T, APIError>) -> ()) {
        AF.request(request)
            .responseData { (response) in
                let result = self.getResult(type: type, result: response.result)
                completion(result)
            }
    }
    
    private func getResult<T: Codable>(type: T.Type, result: Result<Data, AFError>) -> Result<T, APIError> {
        switch result {
        case .success(let data):
            do {
                let json = try JSONDecoder().decode(type, from: data)
                return .success(json)
            } catch(let error) {
                return .failure(.deserializationError(error: error))
            }
        case .failure(let error):
            return .failure(.deserializationError(error: error))
        }
    }
}
