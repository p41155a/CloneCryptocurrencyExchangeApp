//
//  AssetsStatus.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation

/// AppointedAssetsStatus
struct AppointedAssetsStatus: Codable {
    let status: String
    let accountStatus: EachAccountStatus
}

extension AppointedAssetsStatus {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case accountStatus = "data"
    }
}

/// AssetsStatus
struct AssetsStatus: Codable {
    let status: String
    let accountStatus: [String: EachAccountStatus]
}

extension AssetsStatus {
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
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        depositStatus = (try? container?.decode(Int.self, forKey: .depositStatus)) ?? 0
        withdrawalStatus = (try? container?.decode(Int.self, forKey: .withdrawalStatus)) ?? 0
    }
}
