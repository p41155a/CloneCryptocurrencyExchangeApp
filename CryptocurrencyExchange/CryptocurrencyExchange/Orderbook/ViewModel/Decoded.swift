//
//  Decoded.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/07.
//

import Foundation

struct Decoded<T: Codable> {
    var value: T?

    init?(data: Data) {
        value = try? JSONDecoder().decode(T.self, from: data)
    }
}
