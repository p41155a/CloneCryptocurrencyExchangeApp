//
//  CandleChartDataEntries.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import Foundation
import Charts

struct CandleChartDataEntries {
    var values: [CandleChartDataEntry]
    
    init?(with stickValues: [[StickValue]]) throws {
        guard !stickValues.isEmpty else { return nil }
        self.values = try stickValues.enumerated().map { (index, value) -> CandleChartDataEntry in
            guard value.count == 6 else {
                throw CandleChartDataEntriesError.formatMismatched
            }
            let high = value[3].value
            let low = value[4].value
            let open = value[1].value
            let close = value[2].value
            
            return CandleChartDataEntry(
                x: Double(index),
                shadowH: high,
                shadowL: low,
                open: open,
                close: close,
                icon: nil
            )
        }
    }
}


enum CandleChartDataEntriesError: Error {
    case formatMismatched
}
