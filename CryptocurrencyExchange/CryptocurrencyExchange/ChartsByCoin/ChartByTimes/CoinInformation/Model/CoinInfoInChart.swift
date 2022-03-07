//
//  CoinInfoInChart.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/07.
//

import UIKit

enum CoinInfoInChart {
    case si(Double)
    case go(Double)
    case jeo(Double)
    case jong(Double)
    
    var description: String {
        switch self {
        case .si(let value): return String(format: "%.0f", value)
        case .go(let value): return String(format: "%.0f", value)
        case .jeo(let value): return String(format: "%.0f", value)
        case .jong(let value): return String(format: "%.0f", value)
        }
    }
    
    var texts: String {
        switch self {
        case .si(_): return "시\(description)"
        case .go(_): return "고\(description)"
        case .jeo(_): return "저\(description)"
        case .jong(_): return "종\(description)"
        }
    }
}
