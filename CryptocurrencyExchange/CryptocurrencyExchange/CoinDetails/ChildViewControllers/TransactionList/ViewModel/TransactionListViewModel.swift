//
//  TransactionListViewModel.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import Foundation

class TransactionListViewModel: XIBInformation {
    var nibName: String?
    let paymentCurrency: String
    let orderCurrency: String
    let repository: TransactionListRepository
    let indiceToReload: Observable<[IndexPath]?>
    var transactionInformations: [TransactionInforamtion]
    
    init(nibName: String?,
         paymentCurrency: String,
         orderCurrency: String
    ) {
        self.nibName = nibName
        self.paymentCurrency = paymentCurrency
        self.orderCurrency = orderCurrency
        self.repository = TransactionListRepository(
            webSocketManager: TransactionWebSocketManager(
                paymentCurrency: paymentCurrency,
                orderCurrency: orderCurrency
            )
        )
        self.indiceToReload = Observable(nil)
        transactionInformations = []
        self.bindClosures()
    }
    
    private func bindClosures() {
        repository.transactionInformations.bind { [weak self] informations in
            guard let infos = informations else { return }
            infos.map({print($0.date)})
            let newInformations: [TransactionInforamtion] = infos.reversed()
            self?.transactionInformations.insert(contentsOf: newInformations, at: 0)
            self?.indiceToReload.value = newInformations.enumerated().map({ (index, _) -> [IndexPath] in
                [IndexPath(item: index*3, section: 0), IndexPath(item: index*3 + 1, section: 0), IndexPath(item: index*3 + 2, section: 0)
                 
                ]}).flatMap({$0})
            
            
        }
    }
    
    func countOfInformations() -> Int {
        return transactionInformations.count * 3
    }
    
    func information(with index: Int) -> TransactionInforamtion {
        return transactionInformations[index]
    }
    
    func socketConnect(on: Bool = true) {
        repository.socketConnect(on: on)
    }
}
