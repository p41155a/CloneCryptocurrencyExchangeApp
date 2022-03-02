//
//  MockCandleStickRepository.swift
//  CryptocurrencyExchangeTests
//
//  Created by 정다연 on 3/2/22.
//

import Foundation
@testable import CryptocurrencyExchange

class MockCandleStickAPIManager: CandleStickRepository {
    var parameters: CandleStickParameters?
    
    func candleStick(
        parameters: CandleStickParameters,
        completion: @escaping (Result<CandleStickEntity, APIError>?) -> ()
    ) {
        self.parameters = parameters
        completion(nil)
    }
    

}

///  MockCandleStickAPIManager의 candleStick 메서드 호출
///  메서드 내에서 parameter만 바인딩
class MockCandleStickRepository: CandleStickChartRepository {
    let apiManager: MockCandleStickAPIManager = MockCandleStickAPIManager()
    
    func getCandleStickData(parameter: CandleStickParameters, completion: @escaping ([[StickValue]]) -> Void) {
        apiManager.candleStick(
            parameters: parameter) { result in
                completion([[]])
            }
    }
    
    func parameters() -> CandleStickParameters? {
        return apiManager.parameters
    }
}
