//
//  ConclusionEntity.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import Foundation

struct ConclusionTableViewEntity {
    let fasteningStrength: String        // 체결강도
    let contPrice: String                // 체결 가격
    let contQty: String                  // 체결 수량
    
    init(fasteningStrength: String = "",
         contPrice: String = "",
         contQty: String = "") {
        self.fasteningStrength = fasteningStrength
        self.contPrice = contPrice
        self.contQty = contQty
    }
}
