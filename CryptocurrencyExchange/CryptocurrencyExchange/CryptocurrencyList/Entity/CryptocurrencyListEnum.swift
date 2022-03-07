//
//  CryptocurrencyListEnum.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/07.
//

import UIKit

enum MainListSortStandard {
    case currencyName   // 가상자산명
    case currentPrice   // 현재가
    case changeRate     // 변동률
    case transaction    // 거래금액
}

enum OrderBy {
    case asc
    case desc
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

