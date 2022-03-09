//
//  CandleStickRepository.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import Foundation
import RealmSwift

protocol CandleStickChartRepository {
    func getCandleStickData(
        parameter: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    )
    func candleStickDatas(by parameter: CandleStickParameters) -> [CandleStickData]?
}

///  CandleStickAPIManager의 candleStick 메서드 호출
///  메서드 내에서 실제 API 호출
class ProductionCandleStickRepository: CandleStickChartRepository {
    let realm: Realm = try! Realm()
    let dbManager = CandleStickDBManager()
    
    /// 시간 간격별 캔들스틱 데이터 반환
    /// DB에 저장되어 있는 해당 시간 간격의 데이터가 있을 경우: DB 데이터 반환
    /// 없을 경우: API 호출하여 반환
    func getCandleStickData(
        parameter: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        if let candleStickDatas = candleStickDatas(by: parameter) {
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
                    parameter: parameter,
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
        parameter: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        /// 해당 parameter에 해당하는 데이터가 저장되어 있지 않은 경우, realm에 추가
        guard let existingDatas = dbManager.existingData(with: parameter) else {
            dbManager.add(
                data: data,
                parameters: parameter,
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
            print("DB에 업데이트")
            completion(candleStickDatas)
        }
    }
    
            print("DB에 새로운 데이터 추가")
    /// DB에 저장되어 있는 캔들스틱 Data 반환
    func candleStickDatas(by parameter: CandleStickParameters) -> [CandleStickData]? {
        /// DB에 저장되어 있는 데이터가 없을 경우
        guard let candleStickDatas = dbManager.existingData(with: parameter) else {
            print("없음")
            return nil
        }
        
        /// DB에 있는 데이터가 갱신이 필요할 경우
        let timestampToUpdate = candleStickDatas.lastUpdated + parameter.chartInterval.timeInterval
        let currentTimestamp = Date().timeIntervalSince1970
        if timestampToUpdate < currentTimestamp {
            print("DB에 있지만 갱신 필요")
            return nil
        }
    
        print("DB 그대로")
        return candleStickDatas.stickDatas.map({$0})
    }
}
