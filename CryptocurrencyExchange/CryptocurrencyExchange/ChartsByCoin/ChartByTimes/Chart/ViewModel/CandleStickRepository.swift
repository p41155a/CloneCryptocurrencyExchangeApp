//
//  CandleStickRepository.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import Foundation
import RealmSwift

protocol CandleStickChartRepository {
    func getCandleStickData(parameter: CandleStickParameters, completion: @escaping ([CandleStickData]?) -> Void)
    func candleStickDatas(by timeInterval: TimeIntervalInChart) -> [CandleStickData]?
}

///  CandleStickAPIManager의 candleStick 메서드 호출
///  메서드 내에서 실제 API 호출
class ProductionCandleStickRepository: CandleStickChartRepository {
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func getCandleStickData(
        parameter: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        if let candleStickDatas = candleStickDatas(by: parameter.chartInterval) {
            completion(candleStickDatas)
            return
        }
        
        CandleStickAPIManager().candleStick(
            parameters: parameter
        ) { result in
            switch result {
            case .success(let data):
                self.writeCandleStickDatas(
                    with: data.data,
                    intervalType: parameter.chartInterval,
                    completion: completion
                )
            default:
                completion(nil)
            }
        }
    }
}

/// DB에 캔들스틱 data 추가/조회/업데이트
extension ProductionCandleStickRepository {
    /// API의 응답데이터를 DB에 추가
    private func writeCandleStickDatas(
        with data: [[StickValue]],
        intervalType: TimeIntervalInChart,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        var candleStickDatas = [CandleStickData]()
        try! realm.write {
            let sticksByTimeInterval = CandleStickByTimeInterval(
                interval: intervalType,
                lastUpdated: Date()
            )
            data.forEach { stickValues in
                let data = CandleStickData(values: stickValues)
                sticksByTimeInterval.stickDatas.append(data)
                candleStickDatas.append(data)
            }
            realm.add(sticksByTimeInterval)
            completion(candleStickDatas)
        }
    }
    
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
