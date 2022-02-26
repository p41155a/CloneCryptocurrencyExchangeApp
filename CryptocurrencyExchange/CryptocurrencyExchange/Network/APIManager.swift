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
                let result = self.getResult(type: type, response: response)
                completion(result)
            }
    }
    
    private func getResult<T: Codable>(type: T.Type, response: AFDataResponse<Data>) -> Result<T, APIError> {
        let result = response.result
        switch result {
        case .success(let data):
            do {
                let statusCode: Int = response.response?.statusCode ?? 0
                if statusCode == 200 {
                    let json = try JSONDecoder().decode(type, from: data)
                    return .success(json)
                } else {
                    let json = try JSONDecoder().decode(ErrorEnity.self, from: data)
                    return .failure(.bithumbDefinedError(error: json))
                }
            } catch(_) {
                return .failure(.incorrectFormat)
            }
        case .failure(let error):
            return .failure(.failureResponse(error: error))
        }
    }
}
