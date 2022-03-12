//
//  SortDBManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/11.
//

import RealmSwift

class SortDBManager: DBAccessable {
    typealias T = SortInfo
    
    func existingData() -> T? {
        let sortData = suitableData(condition: nil)
        return sortData.first
    }
    
    func add(sortInfo: T, completion: @escaping (Result<T?, Error>) -> ()) {
        addWithUpdate(data: sortInfo) { result in
            completion(result)
        }
    }
}
