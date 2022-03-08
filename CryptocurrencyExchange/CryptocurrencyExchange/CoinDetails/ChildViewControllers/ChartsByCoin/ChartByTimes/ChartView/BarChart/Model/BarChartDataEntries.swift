//
//  BarChartDataEntries.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/07.
//

import Foundation
import Charts

struct BarChartDataEntries {
    var values: [BarChartDataEntry]
    var isOverThanZero: [Bool]
    
    init(dataFromDB: [CandleStickData]) {
        let datas = dataFromDB.enumerated().map({ (index, stickData) -> (BarChartDataEntry, Bool) in
            let amount = stickData.amount
            let isOverThanZero = stickData.close >= stickData.open
            return (BarChartDataEntry(x: Double(index), y: amount), isOverThanZero)
        })
        
        self.values = datas.map({$0.0})
        self.isOverThanZero = datas.map({$0.1})
    }
}


enum BarChartDataEntriesError: Error {
    case formatMismatched
}
