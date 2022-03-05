//
//  CandleStickParameters.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import Foundation

struct CandleStickParameters {
    let orderCurrency: OrderCurrency
    let paymentCurrency: paymentCurrency
    let chartInterval: TimeIntervalInChart
    
    func path() -> String {
        return "\(orderCurrency.value)_\(paymentCurrency.value)/\(chartInterval.urlParameter)"
    }
}
