//
//  AssetsStatusEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation

/// AppointedAssetsStatus
struct AppointedAssetsStatusEntity: Codable {
    let status: String
    let accountStatus: EachAccountStatus
}

extension AppointedAssetsStatusEntity {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case accountStatus = "data"
    }
}

/// AssetsStatus
struct AssetsStatusEntity: Codable {
    let status: String
    let accountStatus: [String: EachAccountStatus]
}

extension AssetsStatusEntity {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case accountStatus = "data"
    }
}

/// EachAccountStatus
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
