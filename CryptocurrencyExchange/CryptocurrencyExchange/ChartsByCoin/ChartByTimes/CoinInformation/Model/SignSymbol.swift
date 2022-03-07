//
//  SignSymbol.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/07.
//

import Foundation

struct SignSymbol {
    var description: String
    
    init(value: Double) {
        if value == 0 {
            self.description = ""
        } else if value > 0 {
            self.description = "+"
        } else {
            self.description = "-"
        }
    }
}
