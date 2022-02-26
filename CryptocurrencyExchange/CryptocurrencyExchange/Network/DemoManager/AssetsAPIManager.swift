//
//  AssetsAPIManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/25.
//

import Foundation

class AssetsAPIManager: APIRequest {
    /// 모든 자산 검색
    func assetsStatus(completion: @escaping (Result<AssetsStatus, APIError>) -> ()) {
        guard let requestURL = APIService.assetsStatus(orderCurrency: OrderCurrency.all.value).setURLRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        request(requestURL: requestURL, type: AssetsStatus.self, completion: completion)
    }
    
    /// 각 자산 검색
    func assetsStatus(cryptocurrencyName: String, completion: @escaping (Result<AppointedAssetsStatus, APIError>) -> ()) {
        guard let requestURL = APIService.assetsStatus(orderCurrency: cryptocurrencyName).setURLRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        request(requestURL: requestURL, type: AppointedAssetsStatus.self, completion: completion)
    }
}
