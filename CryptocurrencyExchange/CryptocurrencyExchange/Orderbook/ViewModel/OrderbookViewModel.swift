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
    var orderCurrency: OrderCurrency
    var paymentCurrency: PaymentCurrency
    private var dataStore = DataStore()

    init(
        nibName: String? = nil,
        orderCurrency: OrderCurrency,
        paymentCurrency: PaymentCurrency
    ) {
        self.nibName = nibName
        self.orderCurrency = orderCurrency
        self.paymentCurrency = paymentCurrency
    }
    
    func set(from data: String) {
        dataStore.checkWebSocketType(for: data)
    }
}

fileprivate class DataStore: DataSetable {
    
//    private let tradeDescriptionList: Observable<[String: TradeDescriptionEntity]> = Observable([:])
//    private let tradeDescriptionList: Observable<[String: TradeDescriptionEntity]> = Observable([:])
    private let tradeDescriptionList: Observable<[String: TradeDescriptionEntity]> = Observable([:])

    private let fasteningStrengthList: Observable<[String: FasteningStrengthEntity]> = Observable([:])
    private let concludedQuantityList: Observable<[String: ConcludedQuantityEntity]> = Observable([:])
    //    private let fasteningStrengthList: Observable<[String: FasteningStrengthEntity]> = Observable([:])
    //    private let fasteningStrengthList: Observable<[String: FasteningStrengthEntity]> = Observable([:])
    
    fileprivate func checkWebSocketType(for data: String) {
        guard let data = data.data(using: .utf8) as? Data,
              let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                  return
              }
        
        if let webSocketType = json["type"] as? String{
            self.approach(to: data, of: WebSocketType(rawValue: webSocketType)?.rawValue ?? "")
        }
    }
    
    /// WebSocket Type별로 접근.
    private func approach(to data: Data, of type: String) {
        switch type {
        case "ticker" :
            guard let json = Decoded<WebSocketTickerEntity>(data: data),
                  let value = json.value else {
                return
            }
            print(value)
            setWebSocketTickerData(with: value)
            
        case "orderbookdepth":
            guard let json = Decoded<WebSocketOrderbookEntity>(data: data),
                  let value = json.value else {
                return
            }
            print(value)
            
        case "transaction":
            guard let json = Decoded<WebSocketTransactionEntity>(data: data),
                  let value = json.value else {
                return
            }
            print(value)
            
        default:
            break
        }
    }
    
    private func setWebSocketOrderData(with entity: WebSocketOrderbookEntity) {
        let tickerInfo = entity.content
//        let currentName = tickerInfo.symbol
        
    }
    
    private func setWebSocketTickerData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        let splitedSymbol: [String] = tickerInfo.symbol.split(separator: "_").map { "\($0)" }
        let currentName = splitedSymbol[0]

        fasteningStrengthList.value[currentName] = setConclusionTableData(for: tickerInfo.volumePower)
        tradeDescriptionList.value[currentName] = setTradeDescriptionData(
            volume: tickerInfo.volume,
            value: tickerInfo.value,
            prevClosePrice: tickerInfo.prevClosePrice,
            openPrice: tickerInfo.openPrice,
            highPrice: tickerInfo.highPrice,
            lowPrice: tickerInfo.lowPrice
        )
    }
    
    private func setWebSocketTransactionData(with entity: WebSocketTransactionEntity) {
        let transactionInfo = entity.content.list
         
        let currentName = transactionInfo[0].symbol
        
        concludedQuantityList.value[currentName] = setConclusionTableData(
            for: transactionInfo[0].contPrice,
            and: transactionInfo[0].contQty
        )
    }
    
    // MARK:  Trade Description
    private func setTradeDescriptionData(
        volume: String,
        value: String,
        prevClosePrice: String,
        openPrice: String,
        highPrice: String,
        lowPrice: String
    ) -> TradeDescriptionEntity {
        
        let volume: String = "\(volume)"
        let value: String = "\(value)"
        let prevClosePrice: String = "\(prevClosePrice)"
        let openPrice: String = "\(openPrice)"
        let highPrice: String = "\(highPrice)"
        let lowPrice: String = "\(lowPrice)"
        
        return TradeDescriptionEntity(
            volume: volume,
            value: value,
            prevClosePrice: prevClosePrice,
            openPrice: openPrice,
            highPrice: highPrice,
            lowPrice: lowPrice
        )
    }
    
    // MARK:  Conclusion Table View 를 위한 데이터입니다.
    /// 체결강도 퍼센트
    private func setConclusionTableData(for fasteningStrength: String) -> FasteningStrengthEntity {
        let fasteningStrength: String = "\(fasteningStrength)%"
        return FasteningStrengthEntity(fasteningStrength: fasteningStrength)
    }
    
    /// 체결 가격, 체결 수량
    private func setConclusionTableData(
        for contPrice: String,
        and contQty: String
    ) -> ConcludedQuantityEntity {
        let contPrice: String = contPrice
        let contQty: String = contQty
        
        return ConcludedQuantityEntity(contPrice: contPrice, contQty: contQty)
    }
}

