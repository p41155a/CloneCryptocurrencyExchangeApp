//
//  CandleStickRepository.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import Foundation

protocol CandleStickChartRepository {
    func getCandleStickData(
        parameter: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    )
    func candleStickDatasInDB(by parameter: CandleStickParameters) throws -> [CandleStickData]?
}

///  CandleStickAPIManager의 candleStick 메서드 호출
///  메서드 내에서 실제 API 호출
class ProductionCandleStickRepository: CandleStickChartRepository {
    let dbManager = CandleStickDBManager()
    
    /// 시간 간격별 캔들스틱 데이터 반환
    /// DB에 저장되어 있는 해당 시간 간격의 데이터가 최신 데이터일 경우: DB 데이터 반환
    /// 아닐 경우: API 호출하여 반환
    ///  - Parameter parameter: 가져올 데이터의 식별자 역할을 하는 파라미터 전달
    ///  - Parameter completion: 최신데이터 반환
    func getCandleStickData(
        parameter: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        do {
            let candleStickDatas = try candleStickDatasInDB(by: parameter)
            completion(candleStickDatas)
        } catch {
            CandleStickAPIManager().candleStick(
                parameters: parameter
            ) { result in
                switch result {
                case .success(let data):
                    self.writeCandleStickDatas(
                        with: data.data,
                        type: error as! CandleStickDBError,
                        parameter: parameter,
                        completion: completion
                    )
                default:
                    completion(nil)
                }
            }
        }
    }
}

/// DB에 캔들스틱 data 추가/조회/업데이트
extension ProductionCandleStickRepository {
    
    /// API의 응답데이터를 DB에 추가
    private func writeCandleStickDatas(
        with data: [[StickValue]],
        type: CandleStickDBError,
        parameter: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        switch type {
        case .noExist:      // 해당 parameter에 해당하는 데이터가 저장되어 있지 않은 경우, realm에 추가
            dbManager.add(
                responseData: data,
                parameters: parameter,
                completion: completion
            )
        case .needToUpdate: // 해당 intervalType에 해당하는 데이터가 저장되어 있는 경우, 기존 데이터에 업데이트
            guard let existingDatas = dbManager.existingData(with: parameter) else {
                return
            }
            dbManager.update(
                stickValuesArr: data,
                existingDatas: existingDatas
            ) {
                completion(existingDatas.stickDatas.map({$0}))
            }
        }
    }
    
    /// DB에 저장되어 있는 캔들스틱 Data 반환
    /// - Returns: 현재 갖고 있는 캔들스틱 데이터가 최신 데이터일 경우 반환
    func candleStickDatasInDB(by parameter: CandleStickParameters) throws -> [CandleStickData]? {
        /// DB에 저장되어 있는 데이터가 없을 경우
        guard let candleStickDatas = dbManager.existingData(with: parameter) else {
            throw CandleStickDBError.noExist
        }
        
        /// DB에 있는 데이터가 갱신이 필요할 경우
        if shouldUpdateNewCandleStick(
            last: candleStickDatas.lastUpdated,
            interavl: parameter.timeInterval()
        ) {
            throw CandleStickDBError.needToUpdate
        }
        
        return candleStickDatas.stickDatas.map({$0})
    }
    
    private func shouldUpdateNewCandleStick(
        last lastUpdatedTimeInterval: Double,
        interavl currentTimeInterval: Double
    ) -> Bool {
        let timeIntervalToUpdate = lastUpdatedTimeInterval + currentTimeInterval
        let currentTimeInterval = Date().timeIntervalSince1970
        return timeIntervalToUpdate < currentTimeInterval
    }
}
