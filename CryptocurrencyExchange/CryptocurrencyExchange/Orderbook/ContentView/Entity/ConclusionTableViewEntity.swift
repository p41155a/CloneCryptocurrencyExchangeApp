//
//  ConclusionEntity.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import Foundation

struct FasteningStrengthEntity {
    let fasteningStrength: String       // 체결강도
    init(fasteningStrength: String = "") {
        self.fasteningStrength = fasteningStrength
    }
}

struct ConcludedQuantityEntity {
    let contPrice: String                // 체결 가격
    let contQty: String                  // 체결 수량
    init(contPrice: String = "", contQty: String = "") {
        self.contPrice = contPrice
        self.contQty = contQty
    }
}
