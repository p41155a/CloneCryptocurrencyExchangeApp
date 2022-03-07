//
//  CryptocurrencyListEnum.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/07.
//

import UIKit
import RealmSwift

enum MainListSortStandard: String, PersistableEnum {
    case currencyName = "currencyName"  // 가상자산명
    case currentPrice = "currentPrice"  // 현재가
    case changeRate = "changeRate"      // 변동률
    case transaction = "transaction"    // 거래금액
}

enum OrderBy: String, PersistableEnum {
    case asc = "asc"
    case desc = "desc"
    
    func toggle() -> OrderBy {
        switch self {
        case .asc:
            return .desc
        case .desc:
            return .asc
        }
    }
}

enum UpDown: Character {
    case up = "+"
    case down = "-"
    case zero = "0"
    
    var color: UIColor {
        switch self {
        case .up:
            return .increasingColor ?? .red
        case .down:
            return .decreasingColor ?? .blue
        case .zero:
            return .titleColor ?? .black
        }
    }
}

