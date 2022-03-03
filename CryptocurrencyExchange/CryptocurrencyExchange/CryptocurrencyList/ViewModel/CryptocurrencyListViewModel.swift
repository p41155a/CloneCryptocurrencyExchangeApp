//
//  CryptocurrencyListViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import Foundation

protocol CryptocurrencyListViewModelDelegate: AnyObject {
    func showAlert(message: String)
}
final class CryptocurrencyListViewModel: XIBInformation {
    // MARK: - Property
    private var apiManager = TickerAPIManager()
    weak var delegate: CryptocurrencyListViewModelDelegate?
    var nibName: String?
    /// Property about data
    let tickerKRWList: Observable<[String: CrypotocurrencyListTableViewEntity]> = Observable([:])
    var currencyNameList: Observable<[String]> = Observable([])
    
    // MARK: - init
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
    
    // MARK: - Func
    func setKRWInitialData() {
        apiManager.fetchTicker(paymentCurrency: .KRW) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.currentInfo.current
                var tickerKRWList: [String: CrypotocurrencyListTableViewEntity] = [:]
                var currencyNameList: [String] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let tableData = CrypotocurrencyListTableViewEntity(symbol: "\(tickerInfo.currentName ?? "")_\(PaymentCurrency.KRW)",
                                                                       currentPrice: tickerInfo.closingPrice ?? "",
                                                                       changeRate: "",
                                                                       changeAmount: "",
                                                                       transactionAmount: "")
                    currencyNameList.append(currentName)
                    tickerKRWList[currentName] = tableData
                }
                self.tickerKRWList.value = tickerKRWList
                self.currencyNameList.value = currencyNameList
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
            }
        }
    }
    
    func setWebSocketData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        /// symbol 분리
        let splitedSymbol: [String] = tickerInfo.symbol.split(separator: "_").map { "\($0)" }
        let currentName = splitedSymbol[0]
        let payment = splitedSymbol[1]
        /// 보여지는 값과 다르게 내려오는 데이터 변환
        let currentPrice: String = tickerInfo.closePrice.doubleValue?.decimalType ?? tickerInfo.closePrice
        let changeRate: String = "\(tickerInfo.chgRate.doubleValue?.displayDecimal(to: 2) ?? tickerInfo.chgRate)%"
        let changeAmount: String = tickerInfo.chgAmt.doubleValue?.decimalType ?? tickerInfo.chgAmt
        let transactionAmount: String = "\(Int((tickerInfo.value.doubleValue ?? 0) / 1000000).decimalType ?? "")백만"
        
        let tableData = CrypotocurrencyListTableViewEntity(symbol: "\(currentName)_\(payment)",
                                                           currentPrice: currentPrice,
                                                           changeRate: changeRate,
                                                           changeAmount: changeAmount,
                                                           transactionAmount: transactionAmount)
        
        if payment == PaymentCurrency.KRW.value {           /// 지불 방식: KRW
            tickerKRWList.value[currentName] = tableData
        } else if payment == PaymentCurrency.BTC.value {    /// 지불 방식: BTC
            
        }
    }
}
