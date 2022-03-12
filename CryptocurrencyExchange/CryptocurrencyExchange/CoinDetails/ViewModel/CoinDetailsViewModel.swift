//
//  CoinDetailsViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import Foundation
import Network

class CoinDetailsViewModel: XIBInformation {
    var nibName: String?
    var dependency: CryptocurrencyListTableViewEntity
    
    let apiManager = CandleStickAPIManager()
    var interestDB = InterestDBManager()
    
    /// 코인상세페이지에서 사용되는 ticker 데이터 관리
    var tickerSocketManager: TickerWebSocketManager
    let tickerData: Observable<WebSocketTickerContent?> = Observable(nil)
    
    let error: Observable<String?> = Observable(nil)
    
    init(
        nibName: String?,
        dependency: CryptocurrencyListTableViewEntity
    ) {
        self.nibName = nibName
        self.dependency = dependency
        self.tickerSocketManager = TickerWebSocketManager(
            symbols: "\(dependency.order)_\(dependency.payment.value)"
        )
        self.bindClosures()
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

    func getWebSocketSymbol() -> String {
        return "\(dependency.order)_\(dependency.payment.value)"
    }
    
    func connectSocket() {
        tickerSocketManager.connect()
    }
    
    func disconnectSocket() {
        tickerSocketManager.disconnect()
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
    
    private func bindClosures() {
        tickerSocketManager.tickerData.bind { [weak self] data in
            self?.tickerData.value = data
        }
    }
}
