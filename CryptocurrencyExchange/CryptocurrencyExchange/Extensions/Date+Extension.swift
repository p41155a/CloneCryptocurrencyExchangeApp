//
//  Date+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/09.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
        
    }
}
