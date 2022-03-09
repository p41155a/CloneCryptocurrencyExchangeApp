//
//  CandleStickParameters.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import Foundation

struct CandleStickParameters {
    let orderCurrency: OrderCurrency
    let chartInterval: TimeIntervalInChart
    let paymentCurrency: PaymentCurrency
    
    func path() -> String {
        return "\(orderCurrency.value)_\(paymentCurrency.value)/\(chartInterval.urlParameter)"
    }
    
    func timeInterval() -> Double {
        return chartInterval.timeInterval
    }
}
