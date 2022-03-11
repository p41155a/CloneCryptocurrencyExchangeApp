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
    
    func isInterest(of interestKey: String) -> Bool {
        let interestData = suitableData() { interestInfo in
            return (interestInfo.currency == interestKey &&
                    interestInfo.interest == true)
        }
        return !interestData.isEmpty
    }
    
    func add(interest: T, completion: @escaping (Result<T?, Error>) -> ()) {
        addWithUpdate(data: interest) { result in
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
