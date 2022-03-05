//
//  CandleStickParameters.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import Foundation

struct CandleStickParameters {
    let orderCurrency: OrderCurrency
    let paymentCurrency: PaymentCurrency
    let chartInterval: CandleStickIntervals
    
    func path() -> String {
        return "\(orderCurrency.value)_\(paymentCurrency.value)/\(chartInterval.rawValue)"
    }
}
