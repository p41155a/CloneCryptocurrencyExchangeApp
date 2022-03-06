//
//  OrderbookViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import Foundation

protocol DataSetable {
    func checkWebSocketType(for data: String)
}

class OrderbookViewModel: XIBInformation {
    var nibName: String?
    private var dataStore = DataStore()
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
    
    func set(from data: String) {
        dataStore.checkWebSocketType(for: data)
    }
}

fileprivate class DataStore: DataSetable {
    fileprivate func checkWebSocketType(for data: String) {
        guard let data = data.data(using: .utf8) as? Data,
              let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                  return
              }
        
        if let webSocketType = json["type"] as? String{
            self.approach(to: data, of: WebSocketType(rawValue: webSocketType)?.rawValue ?? "")
        }
    }
    
    private func approach(to data: Data, of type: String) {
        switch type {
        case "ticker" :
            print("type1 :",type)
            do {
                let json = try JSONDecoder().decode(WebSocketTickerEntity.self, from: data)
                print(json)
            } catch  {
            }
        case "orderbookdepth":
            print("type2 :",type)
            do {
                let json = try JSONDecoder().decode(WebSocketOrderbookEntity.self, from: data)
                print(json)
            } catch  {
            }
        case "transaction":
            print("type3 :",type)
            do {
                let json = try JSONDecoder().decode(WebSocketTransactionEntity.self, from: data)
                print(json)
            } catch  {
            }
        default:
            break
        }
    }
}
