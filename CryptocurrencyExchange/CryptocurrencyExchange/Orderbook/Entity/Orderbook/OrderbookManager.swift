//
//  OrderbookManager.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/11.
//

import Foundation
import Alamofire

protocol OrderbookManagerDelegate: AnyObject {
    func coinOrderbookDataManager(didChange askOrderbooks: [OrderbookEntity], and bidOrderbooks: [OrderbookEntity])
    func coinOrderbookDataManager(didCalculate totalQuantity: Double, type: WebSocketEachOrderbook.OrderType)
}

final class OrderbookManager: APIProvider {
    weak var delegate: OrderbookManagerDelegate?

    func calculateTotalOrderQuantity(
        orderbooks: [OrderbookEntity],
        type: WebSocketEachOrderbook.OrderType
    ) {
        let totalQuantity = orderbooks.compactMap { orderbook in
            Double(orderbook.quantity)
        }.reduce(0, +)
        
        let digit: Double = pow(10, 5)
        let roundedQuantity = round(totalQuantity * digit) / digit
        
        delegate?.coinOrderbookDataManager(didCalculate: roundedQuantity, type: type)
    }

    func updateOrderbook(
        orderbooks: [OrderbookEntity],
        to currentOrderbooks: inout [OrderbookEntity],
        type : WebSocketEachOrderbook.OrderType
    ) {
        var newData: [String: Double] = [:]
        var oldData: [String: Double] = [:]
        
        orderbooks.forEach { orderbook in
            newData[orderbook.price] = Double(orderbook.quantity)
        }
        
        currentOrderbooks.forEach { orderbook in
            oldData[orderbook.price] = Double(orderbook.quantity)
        }
        
        newData.merge(oldData) { (new, _) in new }
        
        let resultOrderbooks: [OrderbookEntity] = newData
            .filter { $0.value > 0 }
            .map { OrderbookEntity(
                price: $0.key,
                quantity: String($0.value),
                type: type)
            }
            .sorted {
                $0.price > $1.price
            }
        
        if resultOrderbooks.count > 30 {
            currentOrderbooks = resultOrderbooks.dropLast(resultOrderbooks.count - 30)
            return
        }
        
        currentOrderbooks = resultOrderbooks
    }
}
