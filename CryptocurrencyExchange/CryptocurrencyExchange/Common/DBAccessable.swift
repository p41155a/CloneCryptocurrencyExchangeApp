//
//  DBAccessable.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/09.
//

import Foundation
import RealmSwift

protocol DBAccessable {
    associatedtype T: Object
    var realm: Realm { get }
    func suitableData(condition: ((Query<T>) -> Query<Bool>)?) -> Results<T>
    func add(data: T, completion: @escaping (Result<T?, Error>) -> ())
    func addWithUpdate(data: T, completion: @escaping (Result<T?, Error>) -> ())
    func update(block: (() -> Void), completion: @escaping (Result<(), Error>) -> ())
}

extension DBAccessable {
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            NSLog("DB로드에 실패하였습니다.")
        }
        return self.realm
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
    
    func add(data: T, completion: @escaping (Result<T?, Error>) -> ()) {
        do  {
            try realm.write {
                realm.add(data)
                completion(.success(data))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func addWithUpdate(data: T, completion: @escaping (Result<T?, Error>) -> ()) {
        do {
            try realm.write {
                realm.add(data, update: .modified)
                completion(.success(data))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func update(block: (() -> Void), completion: @escaping (Result<(), Error>) -> ()) {
        do {
            try realm.write({
                block()
                completion(.success(()))
            })
        } catch {
            completion(.failure(error))
        }
    }
}

