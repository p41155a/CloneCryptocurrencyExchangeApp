//
//  DBAccessable.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/09.
//

import Foundation
import RealmSwift

protocol DBAccessable {
    associatedtype T: RealmFetchable
    var realm: Realm { get }
    func suitableData(condition: ((Query<T>) -> Query<Bool>)?) -> Results<T>
}

extension DBAccessable {
    var realm: Realm {
        return try! Realm()
    }
    
    func suitableData(condition: ((Query<T>) -> Query<Bool>)?) -> Results<T> {
        let savedData = realm.objects(T.self)
        guard let condi = condition else {
            return savedData
        }
        return savedData.where { datas in
            condi(datas)
        }
    }
}

