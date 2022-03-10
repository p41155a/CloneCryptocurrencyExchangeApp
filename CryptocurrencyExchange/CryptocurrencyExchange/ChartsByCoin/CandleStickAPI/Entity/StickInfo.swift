//
//  StickInfo.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/10.
//

import Foundation

struct StickInfo {
    let time: Double
    let openPrice: Double
    let closePrice: Double
    let minPrice: Double
    let maxPrice: Double
    let volume: Double
    
    init?(data: [StickValue]) {
        guard let time = data[safe: 0]?.value,
              let openPrice = data[safe: 1]?.value,
              let closePrice = data[safe: 2]?.value,
              let minPrice = data[safe: 3]?.value,
              let maxPrice = data[safe: 4]?.value,
              let volume = data[safe: 5]?.value else {
                  return nil
              }
        
        self.time = time
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.volume = volume
    }
}
