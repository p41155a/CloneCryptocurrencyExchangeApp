//
//  TransactionAPIManager.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/12.
//

import Foundation

class TransactionAPIManager: APIProvider {
    /// 각 자산 검색
    func fetchTransaction(
        orderCurrency: OrderCurrency,
        paymentCurrency: PaymentCurrency,
        completion: @escaping (Result<TransactionValue, APIError>
        ) -> ()) {
        guard let requestURL = TransactionAPIService.list(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency).setRequest() else {
            completion(.failure(APIError.invalidURL))
            return
        }
        fetchResponse(requestURL: requestURL, completion: completion)
    }
}
