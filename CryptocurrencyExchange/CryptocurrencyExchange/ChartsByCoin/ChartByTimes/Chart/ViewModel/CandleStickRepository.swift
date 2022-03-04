//
//  CandleStickRepository.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import Foundation
import RealmSwift

protocol CandleStickChartRepository {
    func getCandleStickData(parameter: CandleStickParameters, completion: @escaping ([[StickValue]]) -> Void)
    func candleStickDatas(by timeInterval: TimeIntervalInChart) -> [CandleStickData]?
}

///  CandleStickAPIManager의 candleStick 메서드 호출
///  메서드 내에서 실제 API 호출
class ProductionCandleStickRepository: CandleStickChartRepository {
    func getCandleStickData(parameter: CandleStickParameters, completion: @escaping ([[StickValue]]) -> Void) {
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
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

/// DB에 캔들스틱 data 추가/조회/업데이트
extension ProductionCandleStickRepository {
    /// DB에 저장되어 있는 캔들스틱 Data 반환
    func candleStickDatas(by timeInterval: TimeIntervalInChart) -> [CandleStickData]? {
        let candleSticks = realm.objects(CandleStickByTimeInterval.self)
        
        let candleSticByInterval = candleSticks.where {
            $0.interval == timeInterval
        }.first
        
        guard let candleStickDatas = candleSticByInterval else {
            return nil
        }
        
        return candleStickDatas.stickDatas.map({$0})
    }
}
