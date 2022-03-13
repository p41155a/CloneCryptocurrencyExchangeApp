//
//  CandleStickEntity.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import Foundation

// MARK: - CandleStickEntity
struct StickValue: Codable {
    var value: Double

    init(value: Double?) {
        guard let val = value else {
            self.value = 0
            return
        }
        
        self.value = val
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = StickValue(value: x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = StickValue(value: Double(x))
            return
        }
        throw DecodingError.typeMismatch(
            StickValue.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum")
        )
    }
}
