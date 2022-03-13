//
//  AssetsStatusEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation

// MARK: - AssetsStatusEntity
struct EachAccountStatus: Codable {
    let depositStatus: Int
    let withdrawalStatus: Int
}

extension EachAccountStatus {
    enum CodingKeys: String, CodingKey {
        case depositStatus = "deposit_status"
        case withdrawalStatus = "withdrawal_status"
    }
}
