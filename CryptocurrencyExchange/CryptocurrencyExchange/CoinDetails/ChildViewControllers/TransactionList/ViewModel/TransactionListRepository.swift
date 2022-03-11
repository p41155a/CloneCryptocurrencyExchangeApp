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
            self?.transactionInformations.value = data?.content.list.map({ content -> TransactionInforamtion in
                let dateFormatted = self?.formattedDate(from: content.contDtm) ?? ""
                return TransactionInforamtion(
                    saleType: content.buySellGb,
                    date: dateFormatted,
                    price: content.contPrice,
                    amount: content.contAmt
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
    
    private func formattedDate(from dateString: String) -> String {
        var dateFormatted = dateString
        if let date = dateFormatted.toDate(format: "yyyy-MM-dd HH:mm:ss.SSSSSS") {
            dateFormatted = date.toString(format: "HH:mm:ss")
        }
        
        return dateFormatted
    }
}
