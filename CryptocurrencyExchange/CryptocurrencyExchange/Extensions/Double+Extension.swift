//
//  Double+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/07.
//

import Foundation

extension Double {
    func displayDecimal(to place: Int) -> String {
        return String(format: "%.\(place)f", self)
    }
}
