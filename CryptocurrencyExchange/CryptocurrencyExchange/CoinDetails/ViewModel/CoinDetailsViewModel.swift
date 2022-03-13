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
    
    /// 코인상세페이지에서 공통적으로 사용되는 ticker 데이터 관리
    var tickerSocketManager: SoloSocketManager<WebSocketTickerEntity>
    let tickerData: Observable<WebSocketTickerContent?> = Observable(nil)

    /// 코인상세페이지에서 공통적으로 사용되는 transaction 데이터 관리
    var transactionSocketManager: SoloSocketManager<WebSocketTransactionEntity>
    let transactionData: Observable<WebSocketTransactionContent?> = Observable(nil)
    
    let error: Observable<String?> = Observable(nil)
    
    init(
        nibName: String?,
        dependency: CryptocurrencyListTableViewEntity
    ) {
        self.nibName = nibName
        self.dependency = dependency

        self.tickerSocketManager = SoloSocketManager(
            parameter: [
                "type": WebSocketType.ticker.rawValue,
                "symbols": ["\(dependency.order)_\(dependency.payment.value)"],
                "tickTypes": [WebSocketTickType.tick24H.rawValue]
            ]
        )
        self.transactionSocketManager = SoloSocketManager(
            parameter: [
                "type": "transaction",
                "symbols": ["\(dependency.order)_\(dependency.payment.value)"]
            ]
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
        transactionSocketManager.connect()
    }
    
    func disconnectSocket() {
        tickerSocketManager.disconnect()
        transactionSocketManager.disconnect()
    }

    func setInitialDataForChart(_ completion: @escaping ([[StickValue]]) -> ()) {
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
        tickerSocketManager.socketData.bind { [weak self] data in
            self?.tickerData.value = data?.content
        }
        
        tickerSocketManager.errorMessage.bind { [weak self] error in
            guard self?.tickerSocketManager.socketData.value != nil else { return }
            self?.error.value = error
        }
        
        transactionSocketManager.socketData.bind { [weak self] entity in
            self?.transactionData.value = entity?.content
        }
    }
}
