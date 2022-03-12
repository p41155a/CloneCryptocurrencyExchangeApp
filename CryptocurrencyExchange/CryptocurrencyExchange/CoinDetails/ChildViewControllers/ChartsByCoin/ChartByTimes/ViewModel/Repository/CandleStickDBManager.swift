//
//  CandleStickDBManager.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/09.
//

import RealmSwift
import UIKit

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
        responseData: [[StickValue]],
        parameters: CandleStickParameters,
        completion: @escaping ([CandleStickData]?) -> Void
    ) {
        let sticksByTimeInterval = CandleStickByTimeInterval(
            parameters: parameters
        )
        let candleStickDatas = responseData.map { stickValues -> CandleStickData in
            let data = CandleStickData(values: stickValues)
            sticksByTimeInterval.stickDatas.append(data)
            return data
        }
        sticksByTimeInterval.lastUpdated = candleStickDatas.last?.time ?? 0
        
        add(data: sticksByTimeInterval) { result in
            switch result {
            case .success(_):
                completion(candleStickDatas)
            case .failure(_):
                break
            }
        }
    }
    
    func update(
        stickValuesArr: [[StickValue]],
        existingDatas: T,
        completion: @escaping () -> Void
    ) {
        update(block: {
            let candleStickDataList = existingDatas.stickDatas
            let lastUpdated = existingDatas.lastUpdated
            
            var newDatasToAdd = [CandleStickData]()
            for stickValues in stickValuesArr.reversed() {
                let data = CandleStickData(values: stickValues)
                // 존재하는 최신데이터의 시간보다 최신데이터일 경우에만 추가한다
                if data.time <= lastUpdated { break }
                newDatasToAdd.append(data)
            }
            newDatasToAdd = newDatasToAdd.reversed()
            candleStickDataList.append(objectsIn: newDatasToAdd)
            
            if !newDatasToAdd.isEmpty {
                existingDatas.lastUpdated = newDatasToAdd.last?.time ?? Date().timeIntervalSince1970
            }
        }) { result in
            switch result {
            case .success():
                completion()
            case .failure(_):
                break
            }
        }
    }
}
