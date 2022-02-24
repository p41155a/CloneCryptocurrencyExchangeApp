//
//  APIManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation
import Alamofire

class APIManager {
    #warning("""
        1. escaping 클로저
        2. 오류처리 <오류 처리를 하고 싶지만 responseData가 오류처리하는 함수가 아니라서 안됨 방법이 없을까?>
    """)
    /// 모든 자산 검색
    func assetsStatus(completion: @escaping (Result<AssetsStatus, APIError>) -> ()) {
        guard let request = APIService.assetsStatus(orderCurrency: OrderCurrency.all.value).setURLRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        AF.request(request)
            .responseData { (response) in
                let result = self.getResult(type: AssetsStatus.self, result: response.result)
                completion(result)
            }
    }
    
    /// 각 자산 검색
    func assetsStatus(cryptocurrencyName: String, completion: @escaping (Result<AppointedAssetsStatus, APIError>) -> ()) {
        guard let request = APIService.assetsStatus(orderCurrency: cryptocurrencyName).setURLRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        AF.request(request)
            .responseData { (response) in
                let result = self.getResult(type: AppointedAssetsStatus.self, result: response.result)
                completion(result)
            }
    }
    
    func getResult<T: Codable>(type: T.Type, result: Result<Data, AFError>) -> Result<T, APIError> {
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
