//
//  CoinDetailsViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import Foundation
import Network

class CoinDetailsViewModel: XIBInformation {
    let apiManager = CandleStickAPIManager()
    var nibName: String?
    var dependency: CryptocurrencyListTableViewEntity
    let error: Observable<String?> = Observable(nil)
    
    init(
        nibName: String?,
        dependency: CryptocurrencyListTableViewEntity
    ) {
        self.nibName = nibName
        self.dependency = dependency
    }
    
    func setInitialDataForChart(_ completion: @escaping (CandleStickEntity) -> ()) {
        apiManager.candleStick(
            parameters: CandleStickParameters(
                orderCurrency: .appoint(name: dependency.order),
                chartInterval: .OneDay,
                paymentCurrency: dependency.payment
            )
        ) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                self.error.value = error.debugDescription
            case .none:
                self.error.value = "chart 값을 가져오지 못하였습니다."
            }
        }
    }
}
