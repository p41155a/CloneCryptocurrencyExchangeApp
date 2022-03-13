//
//  CandleStickParameter.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/09.
//

import Foundation
import RealmSwift

class CandleStickIndentifier: Object {
    @Persisted var orderCurrency: String
    @Persisted var chartInterval: String
    @Persisted var paymentCurrency: String
    
    convenience init(
        parameters: CandleStickParameters
    ) {
        self.init()
        self.orderCurrency = parameters.orderCurrency.value
        self.chartInterval = parameters.chartInterval.urlParameter
        self.paymentCurrency = parameters.paymentCurrency.value
    }

    public static func ==(lhs: CandleStickIndentifier, rhs: CandleStickIndentifier) -> Bool {
        return (
            lhs.orderCurrency == rhs.orderCurrency &&
            lhs.chartInterval == rhs.chartInterval &&
            lhs.paymentCurrency == rhs.paymentCurrency
        )
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let identifier = object as? CandleStickIndentifier else { return false }
        return (identifier.orderCurrency == self.orderCurrency &&
                identifier.chartInterval == self.chartInterval &&
                identifier.paymentCurrency == self.paymentCurrency
        )
    }
    
}
