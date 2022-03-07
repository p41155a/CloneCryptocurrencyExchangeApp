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
    
    /// 시간 간격별 캔들스틱 데이터 반환
    /// DB에 저장되어 있는 해당 시간 간격의 데이터가 있을 경우: DB 데이터 반환
    /// 없을 경우: API 호출하여 반환
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
        let candleSticByInterval = realm.objects(CandleStickByTimeInterval.self).where {
            $0.interval == intervalType
        }.first
        
        /// 해당 intervalType에 해당하는 데이터가 저장되어 있지 않은 경우, realm에 추가
        guard let existingDatas = candleSticByInterval else {
            addNewCandleStickDataToRealmDB(
                with: data,
                intervalType: intervalType,
                completion: completion
            )
            return
        }
        
        /// 해당 intervalType에 해당하는 데이터가 저장되어 있는 경우, 기존 데이터에  업데이트
        try! realm.write {
            var candleStickDataList = existingDatas.stickDatas
            candleStickDataList = List<CandleStickData>()
            
            let candleStickDatas = data.map({ stickValues -> CandleStickData in
                let data = CandleStickData(values: stickValues)
                candleStickDataList.append(data)
                return data
            })
            existingDatas.lastUpdated = candleStickDatas.last?.time ?? 0
            completion(candleStickDatas)
        }

    }
    
    private func addNewCandleStickDataToRealmDB(
        with data: [[StickValue]],
        intervalType: TimeIntervalInChart,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        try! realm.write {
            let sticksByTimeInterval = CandleStickByTimeInterval(
                interval: intervalType
            )
            let candleStickDatas =  data.map { stickValues -> CandleStickData in
                let data = CandleStickData(values: stickValues)
                sticksByTimeInterval.stickDatas.append(data)
                return data
            }
            sticksByTimeInterval.lastUpdated = (candleStickDatas.last?.time ?? 0) / 1000
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
        
        /// DB에 저장되어 있는 데이터가 없을 경우
        guard let candleStickDatas = candleSticByInterval else {
            print("없음")
            return nil
        }
        
        /// DB에 있는 데이터가 갱신이 필요할 경우
        let timestampToUpdate = candleStickDatas.lastUpdated + timeInterval.timeInterval
        let currentTimestamp = Date().timeIntervalSince1970
        if timestampToUpdate < currentTimestamp {
            print("갱신 필요")
            return nil
        }
        
        print("있는 걸로 뿌리자")
        return candleStickDatas.stickDatas.map({$0})
    }
}
