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
