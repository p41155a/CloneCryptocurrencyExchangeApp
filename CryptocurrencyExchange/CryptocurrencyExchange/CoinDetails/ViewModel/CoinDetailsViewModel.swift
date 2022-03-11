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
    var interestDB = InterestDBManager()
    var dependency: CryptocurrencyListTableViewEntity
    let error: Observable<String?> = Observable(nil)
    
    init(
        nibName: String?,
        dependency: CryptocurrencyListTableViewEntity
    ) {
        self.nibName = nibName
        self.dependency = dependency
    }
    
    func orderCurrency() -> String {
        return dependency.order
    }
    
    func paymentCurrency() -> String {
        return dependency.payment.value
	}
    
    func isInterest() -> Bool {
        interestDB.isInterest(of: CryptocurrencySymbolInfo(order: dependency.order,
                                                           payment: dependency.payment))
    }
    
    func setInterest(for isInterest: Bool) {
        let symbolInfo = CryptocurrencySymbolInfo(order: dependency.order,
                                                  payment: dependency.payment)
        return interestDB.add(symbolInfo: symbolInfo,
                              isInterest: isInterest) { [weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self?.error.value = "DB를 불러오지 못하였습니다.\n앱을 제거 후 다시 설치해주세요"
            }
        }
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
