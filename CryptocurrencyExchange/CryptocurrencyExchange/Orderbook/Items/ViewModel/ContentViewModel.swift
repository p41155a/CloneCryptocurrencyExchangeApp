//
//  ContentViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/12.
//

import Foundation
import UIKit

protocol Settable {
    /// 소수점 계산
    func calculatePercentage(closePrice: String, price: String, calculatedPrice: Double) -> String
}

final class ContentViewModel: Settable {
    static var shared = ContentViewModel()
    
    func calculatePercentage(
        closePrice: String,
        price: String,
        calculatedPrice: Double
    ) -> String {
        guard let closePrice = Double(closePrice) as? Double,
              let price = Double(price) as? Double else {
                  return ""
              }
        let digit: Double = pow(10, 2)
        
        let absPrice = abs(calculatedPrice)
        let result = (absPrice)/closePrice * 100
        
        return "\(round(result * digit)/digit)"
    }
}

enum PlusMinus: Character {
    case down = "-"
    case up = "+"
    case zero = "0"
    
    var color: UIColor {
        switch self {
        case .up:
            return .increasingColor ?? .red
        case .down:
            return .decreasingColor ?? .blue
        case .zero:
            return .black
        }
    }
}

