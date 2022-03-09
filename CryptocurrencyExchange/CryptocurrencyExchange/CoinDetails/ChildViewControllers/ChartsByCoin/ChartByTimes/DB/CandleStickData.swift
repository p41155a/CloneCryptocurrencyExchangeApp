//
//  CandleStickData.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/09.
//

import Foundation
import RealmSwift

class CandleStickData: Object {
    @Persisted var time: Double // timeInterval(seconds)
    @Persisted var high: Double
    @Persisted var low: Double
    @Persisted var open: Double
    @Persisted var close: Double
    @Persisted var amount: Double

    convenience init(values: [StickValue]) {
        self.init()
        self.time = values[0].value / 1000
        self.high = values[3].value
        self.low = values[4].value
        self.open = values[1].value
        self.close = values[2].value
        self.amount = values[5].value
    }
}
