//
//  CandleStickByTimeInterval.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/4/22.
//

import Foundation
import RealmSwift

class CandleStickByTimeInterval: Object {
    @Persisted var identifier: CandleStickIndentifier!
    @Persisted var lastUpdated: Double
    @Persisted var stickDatas: List<CandleStickData>
    
    convenience init(
        parameters: CandleStickParameters
    ) {
        self.init()
        self.identifier = CandleStickIndentifier(parameters: parameters)
        self.lastUpdated = 0
        self.stickDatas = List<CandleStickData>()
    }
}
