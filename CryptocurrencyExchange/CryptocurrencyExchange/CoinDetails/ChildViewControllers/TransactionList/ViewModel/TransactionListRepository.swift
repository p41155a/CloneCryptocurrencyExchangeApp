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
            self?.transactionInformations.value = data?.content.list.map({ content in
                TransactionInforamtion(
                    saleType: content.buySellGb,
                    date: content.contDtm,
                    price: content.contPrice,
                    amount: content.contAmt
                )
            })
        }
    }
}
