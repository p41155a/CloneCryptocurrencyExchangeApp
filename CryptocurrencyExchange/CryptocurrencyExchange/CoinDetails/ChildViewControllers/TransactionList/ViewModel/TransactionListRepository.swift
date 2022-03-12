//
//  TransactionListRepository.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import Foundation

class TransactionListRepository {
    var transactionDataFromSocket: Observable<WebSocketTransactionContent?>
    var transactionInformations: Observable<[TransactionInforamtion]?>
    let socketManager = SoloSocketManager<WebSocketTransactionEntity>(
        parameter: [
            "type": "transaction",
            "symbols": ["BTC_KRW"]
        ]
    )
    
    init() {
        transactionDataFromSocket = Observable(nil)
        transactionInformations = Observable(nil)
        bindClosures()
    }
    
    func bindClosures() {
        transactionDataFromSocket.bind { [weak self] data in
            guard let `self` = self else { return }
            self.transactionInformations.value = data?.list.map({ content -> TransactionInforamtion in
                return TransactionInforamtion(
                    saleType: content.buySellGb,
                    date: self.formattedDate(from: content.contDtm),
                    price: self.decimal(from: content.contPrice),
                    amount: content.contQty
                )
            })
        }
       bindSampleSocketManager()
    }
    
    private func decimal(from quantity: String) -> String {
        if let quant = Double(quantity),
           let formattedQuantity = quant.decimalType {
            return formattedQuantity
        }
        
        return quantity
    }
    
    private func formattedDate(from dateString: String) -> String {
        var dateFormatted = dateString
        if let date = dateString.toDate(format: "yyyy-MM-dd HH:mm:ss.SSSSSS") {
            dateFormatted = date.toString(format: "HH:mm:ss")
        }
        
        return dateFormatted
    }

    func bindSampleSocketManager() {
        socketManager.socketData.bind { [weak self] data in
            print(data?.content.list.count)
        }
    }
}
