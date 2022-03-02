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
    private var currencyList: [TickerInfo] = []
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
                let cryptocurrencyData = data.currentInfo.current
                self.currencyList = cryptocurrencyData
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
            }
        }
    }
}
