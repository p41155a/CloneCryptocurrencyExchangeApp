//
//  CandleStickRepository.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import Foundation

protocol CandleStickChartRepository {
    func getCandleStickData(parameter: CandleStickParameters, completion: @escaping ([[StickValue]]) -> Void)
}

///  CandleStickAPIManager의 candleStick 메서드 호출
///  메서드 내에서 실제 API 호출
class ProductionCandleStickRepository: CandleStickChartRepository {
    func getCandleStickData(parameter: CandleStickParameters, completion: @escaping ([[StickValue]]) -> Void) {
        CandleStickAPIManager().candleStick(
            parameters: parameter
        ) { result in
                switch result {
                case .success(let data):
                    completion(data.data)
                default:
                    completion([[]])
                }
            }
    }
}
