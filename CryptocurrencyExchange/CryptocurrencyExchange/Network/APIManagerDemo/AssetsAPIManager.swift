//
//  AssetsAPIManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/25.
//

import Foundation

class AssetsAPIManager: APIProvider {
    /// 모든 자산 검색
    func fetchAssetsStatus(completion: @escaping (Result<AssetsStatusEntity, APIError>) -> ()) {
        guard let requestURL = APIService.assetsStatus(orderCurrency: OrderCurrency.all.value).setRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        fetchResponse(requestURL: requestURL, completion: completion)
    }
    
    /// 각 자산 검색
    func fetchAssetsStatus(cryptocurrencyName: String, completion: @escaping (Result<AppointedAssetsStatusEntity, APIError>) -> ()) {
        guard let requestURL = APIService.assetsStatus(orderCurrency: cryptocurrencyName).setRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        fetchResponse(requestURL: requestURL, completion: completion)
    }
}
