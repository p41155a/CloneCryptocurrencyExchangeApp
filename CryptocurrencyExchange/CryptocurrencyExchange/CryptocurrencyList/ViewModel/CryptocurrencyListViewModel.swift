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
    let tickerBTCList: Observable<[String: CrypotocurrencyListTableViewEntity]> = Observable([:])
    var tabKRWList: [(String, PaymentCurrency)] = []
    var tabBTCList: [(String, PaymentCurrency)] = []
    var tabInterestList: [(String, PaymentCurrency)] = []
    var tabPopularList: [(String, PaymentCurrency)] = []
    var currentList: Observable<[(String, PaymentCurrency)]> = Observable([])
    var currentTag: Int = 0 {
        didSet {
            switch currentTag {
            case 0:
                currentList.value = tabKRWList
            case 1:
                currentList.value = tabBTCList
            case 2:
                currentList.value = tabInterestList
            default:
                currentList.value = tabPopularList
            }
        }
    }
    
    // MARK: - init
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
    
    // MARK: - Func
    func setKRWInitialData() {
        let paymentCurrency: PaymentCurrency = .KRW
        apiManager.fetchTicker(paymentCurrency: paymentCurrency) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.currentInfo.current
                var tickerKRWList: [String: CrypotocurrencyListTableViewEntity] = [:]
                var currencyNameList: [(String, PaymentCurrency)] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let tableData = self.setTableData(symbol: tickerInfo.currentName ?? "",
                                                      payment: paymentCurrency,
                                                      currentPrice: tickerInfo.closingPrice ?? "",
                                                      changeRate: tickerInfo.fluctateRate24H ?? "",
                                                      changeAmount: tickerInfo.fluctate24H ?? "",
                                                      transactionAmount: tickerInfo.accTradeValue ?? "")
                    currencyNameList.append((currentName, PaymentCurrency.KRW))
                    tickerKRWList[currentName] = tableData
                }
                self.tickerKRWList.value = tickerKRWList
                self.tabKRWList = currencyNameList
                self.currentList.value = currencyNameList
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
            }
        }
    }
    
    func setBTCInitialData() {
        let paymentCurrency: PaymentCurrency = .BTC
        apiManager.fetchTicker(paymentCurrency: paymentCurrency) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.currentInfo.current
                var tickerBTCList: [String: CrypotocurrencyListTableViewEntity] = [:]
                var currencyNameList: [(String, PaymentCurrency)] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let tableData = self.setTableData(symbol: tickerInfo.currentName ?? "",
                                                      payment: paymentCurrency,
                                                      currentPrice: tickerInfo.closingPrice ?? "",
                                                      changeRate: tickerInfo.fluctateRate24H ?? "",
                                                      changeAmount: tickerInfo.fluctate24H ?? "",
                                                      transactionAmount: tickerInfo.accTradeValue ?? "")
                    currencyNameList.append((currentName, PaymentCurrency.BTC))
                    tickerBTCList[currentName] = tableData
                }
                self.tickerBTCList.value = tickerBTCList
                self.tabBTCList = currencyNameList
                self.currentList.value = currencyNameList
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
        print(payment)
        if payment == "BTC" {
            print(entity)
        }
        let tableData = setTableData(symbol: "\(currentName)",
                                     payment: PaymentCurrency.init(rawValue: payment) ?? .KRW,
                                     currentPrice: tickerInfo.closePrice,
                                     changeRate: tickerInfo.chgRate,
                                     changeAmount: tickerInfo.chgAmt,
                                     transactionAmount: tickerInfo.value)
        
        if payment == PaymentCurrency.KRW.value {           /// 지불 방식: KRW
            tickerKRWList.value[currentName] = tableData
        } else if payment == PaymentCurrency.BTC.value {    /// 지불 방식: BTC
            tickerBTCList.value[currentName] = tableData
        }
    }
    
    private func setTableData(symbol: String, payment: PaymentCurrency, currentPrice: String, changeRate: String, changeAmount: String, transactionAmount: String) -> CrypotocurrencyListTableViewEntity {
        let currentPrice: String = currentPrice.setNumStringForm(isDecimalType: true)
        let changeRate: String = "\(changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let changeAmount: String = changeAmount.setNumStringForm(isDecimalType: true, isMarkPlusMiuns: true)
        let transactionAmount: String = "\(Int((transactionAmount.doubleValue ?? 0) / 1000000).decimalType ?? "")백만"
        
        return CrypotocurrencyListTableViewEntity(symbol: symbol,
                                                  payment: payment,
                                                  currentPrice: currentPrice,
                                                  changeRate: changeRate,
                                                  changeAmount: changeAmount,
                                                  transactionAmount: transactionAmount)
    }
}
