//
//  CommonResponseEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/13.
//

import Foundation

struct CommonResponseEntity<T: Codable>: Codable {
    let status: String
    let data: T
}
