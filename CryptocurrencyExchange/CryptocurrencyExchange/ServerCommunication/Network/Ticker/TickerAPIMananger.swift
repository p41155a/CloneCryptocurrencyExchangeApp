//
//  TickerAPIMananger.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/02.
//

import Foundation

class TickerAPIManager: APIProvider {
    /// 모든 현재가 검색
    func fetchTickerStatus(paymentCurrency: PaymentCurrency,
                           completion: @escaping (Result<TickerEntity, APIError>) -> ()) {
        guard let requestURL = TickerAPIService.ticker(orderCurrency: OrderCurrency.all,
                                                       paymentCurrency: paymentCurrency).setRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        fetchResponse(requestURL: requestURL, completion: completion)
    }
    
    /// 각 현재가 검색
    func fetchTickerStatus(cryptocurrencyName: String,
                           paymentCurrency: PaymentCurrency,
                           completion: @escaping (Result<AppointedTickerEntity, APIError>) -> ()) {
        guard let requestURL = TickerAPIService.ticker(orderCurrency: OrderCurrency.appoint(name: cryptocurrencyName),
                                                       paymentCurrency: paymentCurrency).setRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        fetchResponse(requestURL: requestURL, completion: completion)
    }
}
