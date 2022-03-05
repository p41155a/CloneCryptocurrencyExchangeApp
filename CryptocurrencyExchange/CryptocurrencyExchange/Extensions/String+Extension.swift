//
//  String+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/04.
//

import Foundation

extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    
    func displayDecimal(to place: Int) -> String {
        guard let doubleValue = doubleValue else {
            return self
        }
        return String(format: "%.\(place)f", doubleValue)
    }
    
    func setNumStringForm(isDecimalType: Bool = false, isMarkPlusMiuns: Bool = false) -> String {
        guard let doubleValue = doubleValue else {
            return self
        }
        var result: String = self
        if isDecimalType {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            result = numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        if isMarkPlusMiuns {
            result = doubleValue > 0 ? "+\(result)" : result
        }
        return result
    }
}
