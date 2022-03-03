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
class CryptocurrencyListViewModel: XIBInformation {
    private var tickerKRWList: [String: CrypotocurrencyListTableViewEntity] = [:]
    var currencyNameList: [String] = []
    var krwData: Observable<[CrypotocurrencyListTableViewEntity]> = Observable([])
    private var apiManager = TickerAPIManager()
    weak var delegate: CryptocurrencyListViewModelDelegate?
    var nibName: String?
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
    
    func setKRWInitialData() {
        apiManager.fetchTicker(paymentCurrency: .KRW) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.currentInfo.current
                var krwData: [CrypotocurrencyListTableViewEntity] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let tableData = CrypotocurrencyListTableViewEntity(symbol: "\(tickerInfo.currentName ?? "")_\(PaymentCurrency.KRW)",
                                                                       currentPrice: tickerInfo.closingPrice ?? "",
                                                                       chageRate: "",
                                                                       chageAmount: "",
                                                                       transactionAmount: "")
                    self.currencyNameList.append(currentName)
                    self.tickerKRWList[currentName] = tableData
                    krwData.append(tableData)
                }
                self.krwData.value = krwData
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
            }
        }
    }
    
    func setWebSocketData(with entity: WebSocketTickerEntity) {
        let splitedSymbol: [String] = entity.content.symbol.split(separator: "_").map { "\($0)" }
        let currentName = splitedSymbol[0]
        let payment = splitedSymbol[1]
        if payment == PaymentCurrency.KRW.value {
            let tickerInfo = entity.content
            let tableData = CrypotocurrencyListTableViewEntity(symbol: "\(currentName)_\(PaymentCurrency.KRW)",
                                                               currentPrice: tickerInfo.closePrice,
                                                               chageRate: tickerInfo.chgRate,
                                                               chageAmount: tickerInfo.chgAmt,
                                                               transactionAmount: tickerInfo.value)
            tickerKRWList[currentName] = tableData
            print(tableData)
        }
    }
}
