//
//  Double+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/04.
//

import Foundation

extension Double {
    var decimalType: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))
    }
    
    func displayDecimal(to place: Int) -> String {
        String(format: "%.\(place)f", self)
    }
}
