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
    private var currencyList: [String] = []
    var currencyListKRW: [String] = []
    private var apiManager = TickerAPIManager()
    weak var delegate: CryptocurrencyListViewModelDelegate?
    var nibName: String?
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
    
    func setInitialData() {
        apiManager.fetchTicker(paymentCurrency: .KRW) { result in
            switch result {
            case .success(let data):
                var cryptocurrencyData = data.currentInfo
                cryptocurrencyData["date"] = nil
                print(cryptocurrencyData)
                self.currencyList = cryptocurrencyData.keys.sorted()
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
            }
        }
    }
}
