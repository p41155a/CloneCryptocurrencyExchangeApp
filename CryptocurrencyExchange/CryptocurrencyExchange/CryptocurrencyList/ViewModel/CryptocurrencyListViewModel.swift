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
                    let tableData = self.setTableData(symbol: "\(tickerInfo.currentName ?? "")_\(PaymentCurrency.KRW)",
                                                 currentPrice: tickerInfo.closingPrice ?? "",
                                                 changeRate: tickerInfo.fluctateRate24H ?? "",
                                                 changeAmount: tickerInfo.fluctate24H ?? "",
                                                 transactionAmount: tickerInfo.accTradeValue ?? "")
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
        let splitedSymbol: [String] = tickerInfo.symbol.split(separator: "_").map { "\($0)" }
        let currentName = splitedSymbol[0]
        let payment = splitedSymbol[1]
        
        let tableData = setTableData(symbol: "\(currentName)_\(payment)",
                                     currentPrice: tickerInfo.closePrice,
                                     changeRate: tickerInfo.chgRate,
                                     changeAmount: tickerInfo.chgAmt,
                                     transactionAmount: tickerInfo.value)
        
        if payment == PaymentCurrency.KRW.value {           /// 지불 방식: KRW
            tickerKRWList.value[currentName] = tableData
        } else if payment == PaymentCurrency.BTC.value {    /// 지불 방식: BTC
            
        }
    }
    
    private func setTableData(symbol: String, currentPrice: String, changeRate: String, changeAmount: String, transactionAmount: String) -> CrypotocurrencyListTableViewEntity {
        let currentPrice: String = currentPrice.setNumStringForm(isDecimalType: true)
        let changeRate: String = "\(changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let changeAmount: String = changeAmount.setNumStringForm(isDecimalType: true, isMarkPlusMiuns: true)
        let transactionAmount: String = "\(Int((transactionAmount.doubleValue ?? 0) / 1000000).decimalType ?? "")백만"
        
        return CrypotocurrencyListTableViewEntity(symbol: symbol,
                                                  currentPrice: currentPrice,
                                                  changeRate: changeRate,
                                                  changeAmount: changeAmount,
                                                  transactionAmount: transactionAmount)
    }
}
