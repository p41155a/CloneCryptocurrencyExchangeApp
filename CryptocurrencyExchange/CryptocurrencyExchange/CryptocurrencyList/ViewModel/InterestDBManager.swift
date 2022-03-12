//
//  InterestDBManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/11.
//

import RealmSwift

class InterestDBManager: DBAccessable {
    typealias T = InterestCurrency
    
    func existingData(completion: @escaping ([T]) -> ()) {
        let interestData = suitableData() { interestInfo in
            return interestInfo.interest == true
        }
        completion(interestData.toArray())
    }
    
    func isInterest(of symbolInfo: CryptocurrencySymbolInfo) -> Bool {
        let interestKey = "\(symbolInfo.order)_\(symbolInfo.payment.value)"
        let interestData = suitableData() { interestInfo in
            return (interestInfo.currency == interestKey &&
                    interestInfo.interest == true)
        }
        return !interestData.isEmpty
    }
    
    func add(symbolInfo: CryptocurrencySymbolInfo,
             isInterest: Bool,
             completion: @escaping (Result<T?, Error>) -> ()) {
        let data = InterestCurrency(currency: symbolInfo,
                                    interest: isInterest)
        addWithUpdate(data: data) { result in
            completion(result)
        }
    }
}
extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }
