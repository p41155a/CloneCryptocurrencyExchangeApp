//
//  InterestCurrency.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/13.
//

import Foundation
import RealmSwift

class InterestCurrency: Object {
    @Persisted var currency: String // BTC_KRW
    @Persisted var interest: Bool
    
    convenience init(currency: CryptocurrencySymbolInfo,
                     interest: Bool) {
        self.init()
        self.currency = "\(currency.order)_\(currency.payment.value)"
        self.interest = interest
    }
    
    override static func primaryKey() -> String? {
      return "currency"
    }
}
