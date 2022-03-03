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
    private var tickerList: [String: TickerInfo] = [:]
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
                self.tickerList = cryptocurrencyData
                self.currencyNameList = cryptocurrencyData.keys.sorted()
                self.krwData.value = cryptocurrencyData.values.map { tickerInfo in
                    return CrypotocurrencyListTableViewEntity(symbol: "\(tickerInfo.currentName ?? "")_\(PaymentCurrency.KRW)",
                                                              currentPrice: tickerInfo.closingPrice ?? "",
                                                              chageRate: "",
                                                              chageAmount: "",
                                                              transactionAmount: "")
                }
                print(cryptocurrencyData)
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
            }
        }
    }
}
