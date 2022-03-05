//
//  CandleStickAPIManager.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import Foundation

protocol CandleStickRepository: APIProvider {
    func candleStick(
        parameters: CandleStickParameters,
        completion: @escaping (Result<CandleStickEntity, APIError>?) -> ()
    )
}

class CandleStickAPIManager: CandleStickRepository {
    func candleStick(
        parameters: CandleStickParameters,
        completion: @escaping (Result<CandleStickEntity, APIError>?) -> ()
    ) {
        guard let requestURL = CandleStickAPIService
                .candleStick(candleStickParameters: parameters)
                .setRequest()
        else {
            completion(.failure(APIError.invalidURL))
            return
        }
        fetchResponse(requestURL: requestURL, completion: completion)
    }
}
