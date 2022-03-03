//
//  Int+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/04.
//

import Foundation

extension Int {
    var decimalType: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
