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
}
