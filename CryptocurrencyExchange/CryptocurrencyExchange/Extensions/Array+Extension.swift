//
//  Array+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/10.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
