//
//  ParamOptionDataType.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation
import RealmSwift

enum OrderCurrency {
    case all
    case appoint(name: String)
    
    var value: String {
        switch self {
        case .all:
            return "ALL"
        case .appoint(let name):
            return "\(name)"
        }
    }
}

enum PaymentCurrency: String, PersistableEnum {
    case KRW
    case BTC
    
    var value: String {
        switch self {
        case .KRW:
            return "KRW"
        case .BTC:
            return "BTC"
        }
    }
}
