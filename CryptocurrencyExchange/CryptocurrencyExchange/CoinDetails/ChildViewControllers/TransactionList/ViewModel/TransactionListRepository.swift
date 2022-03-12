//
//  TransactionListRepository.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import Foundation

class TransactionListRepository {
    let webSocketManager: TransactionWebSocketManager
    var transactionInformations: Observable<[TransactionInforamtion]?>
    
    init(webSocketManager: TransactionWebSocketManager) {
        self.webSocketManager = webSocketManager
        self.transactionInformations = Observable(nil)
        self.bindClosures()
    }
    
    func bindClosures() {
        webSocketManager.transactionData.bind { [weak self] data in
            guard let `self` = self else { return }
            self.transactionInformations.value = data?.content.list.map({ content -> TransactionInforamtion in
                return TransactionInforamtion(
                    saleType: content.buySellGb,
                    date: self.formattedDate(from: content.contDtm),
                    price: self.decimal(from: content.contPrice),
                    amount: content.contQty
                )
            })
        }
    }
    
    func socketConnect(on: Bool = true) {
        if on {
            webSocketManager.connect()
        } else {
            webSocketManager.disconnect()
        }
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
}