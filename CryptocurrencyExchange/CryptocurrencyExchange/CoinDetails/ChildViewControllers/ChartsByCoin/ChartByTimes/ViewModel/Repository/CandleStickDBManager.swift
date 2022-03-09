//
//  CandleStickDBManager.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/09.
//

import Foundation
import RealmSwift

class CandleStickDBManager: DBAccessable {
    typealias T = CandleStickByTimeInterval
    
    func existingData(with parameter: CandleStickParameters) -> T? {
        let data: Results<T> = suitableData(condition: { candleStick in
            let id = candleStick.identifier
            let idFromParam = CandleStickIndentifier(parameters: parameter)
            return (id.orderCurrency == idFromParam.orderCurrency &&
                    id.chartInterval == idFromParam.chartInterval &&
                    id.paymentCurrency == idFromParam.paymentCurrency
            )
        })
        return data.first
    }
    
    func add(
        data: [[StickValue]],
        parameters: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        let sticksByTimeInterval = CandleStickByTimeInterval(
            parameters: parameters
        )
        let candleStickDatas = data.map { stickValues -> CandleStickData in
            let data = CandleStickData(values: stickValues)
            sticksByTimeInterval.stickDatas.append(data)
            return data
        }
        sticksByTimeInterval.lastUpdated = candleStickDatas.last?.time ?? 0
        
        add(data: sticksByTimeInterval) { savedDatas in
            print("DB에 새로운 데이터 추가")
            completion(candleStickDatas)
        }
    }
    
    func update(
        stickValuesArr: [[StickValue]],
        existingDatas: T,
        completion: @escaping ([CandleStickData]) -> Void
    ) {
        var candleStickDatas = [CandleStickData]()
        
        update(block: {
            var candleStickDataList = existingDatas.stickDatas
            candleStickDataList = List<CandleStickData>()
            
           candleStickDatas = stickValuesArr.map({ stickValues -> CandleStickData in
                let data = CandleStickData(values: stickValues)
                candleStickDataList.append(data)
                return data
            })
            existingDatas.lastUpdated = candleStickDatas.last?.time ?? 0
        }) {
            print("NEW DB에 업데이트")
            completion(candleStickDatas)
        }
    }
}
