//
//  OrderAPIManager.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/11.
//

import Foundation

class OrderbookAPIManager: APIProvider {
    /// 각 자산 검색
    func fetchOrderbook(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency ,completion: @escaping (Result<OrderBook, APIError>) -> ()) {
        guard let requestURL = OrderbookAPIService.order(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency).setRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        fetchResponse(requestURL: requestURL, completion: completion)
    }
}
