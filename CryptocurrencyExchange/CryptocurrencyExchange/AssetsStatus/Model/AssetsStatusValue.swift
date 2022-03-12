//
//  AssetsStatusValue.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/10.
//

import Foundation

struct AssetsStatusValue: Decodable {
    let status: String
    let assetstatus: [String: AssetStatusData]
    
    enum CodingKeys: String, CodingKey {
        case status
        case assetstatus = "data"
    }
}

struct AssetStatusData: Decodable {
    let withdrawalStatus: Int
    let depositStatus: Int
}
