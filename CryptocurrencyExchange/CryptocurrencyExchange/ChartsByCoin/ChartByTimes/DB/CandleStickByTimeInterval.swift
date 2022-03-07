//
//  CandleStickByTimeInterval.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/4/22.
//

import Foundation
import RealmSwift

class CandleStickByTimeInterval: Object {
    @Persisted var interval: TimeIntervalInChart
    @Persisted var lastUpdated: Double
    @Persisted var stickDatas: List<CandleStickData>
    
    convenience init(
        interval: TimeIntervalInChart
    ) {
        self.init()
        self.interval = interval
        self.lastUpdated = 0
        self.stickDatas = List<CandleStickData>()
    }
}

class CandleStickData: Object {
    @Persisted var time: Double
    @Persisted var high: Double
    @Persisted var low: Double
    @Persisted var open: Double
    @Persisted var close: Double
    @Persisted var amount: Double

    convenience init(values: [StickValue]) {
        self.init()
        self.time = values[0].value
        self.high = values[3].value
        self.low = values[4].value
        self.open = values[1].value
        self.close = values[2].value
        self.amount = values[5].value
    }
}
