//
//  CryptocurrencyListViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import Foundation
import RealmSwift

protocol CryptocurrencyListViewModelDelegate: AnyObject {
    func showAlert(message: String)
}
final class CryptocurrencyListViewModel: XIBInformation {
    // MARK: - Property
    private var timeTrigger = true
    private var timer = Timer()
    private let realm: Realm
    private var apiManager = TickerAPIManager()
    weak var delegate: CryptocurrencyListViewModelDelegate?
    var nibName: String?
    /// Property about data
    let tickerKRWList: Observable<[String: CrypotocurrencyKRWListTableViewEntity]> = Observable([:])
    let tickerBTCList: Observable<[String: CrypotocurrencyBTCListTableViewEntity]> = Observable([:])
    var tabKRWList: [(String, PaymentCurrency)] = []
    var tabBTCList: [(String, PaymentCurrency)] = []
    var tabInterestList: [(String, PaymentCurrency)] = []
    var tabPopularList: [(String, PaymentCurrency)] = []
    var currentList: Observable<[(String, PaymentCurrency)]> = Observable([])
    private var currentTab: Int = 0
    
    // MARK: - init
    init(nibName: String? = nil) {
        self.nibName = nibName
        realm = try! Realm()
    }
    
    // MARK: - Func
    func setInitialData() {
        setBTCInitialData() {}
        setKRWInitialData() { [weak self] in
            guard let self = self else { return }
            self.currentList.value = self.tabKRWList
        }
    }
    
    func setWebSocketData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        let splitedSymbol: [String] = tickerInfo.symbol.split(separator: "_").map { "\($0)" }
        let currentName = splitedSymbol[0]
        let payment = splitedSymbol[1]
        
        if payment == PaymentCurrency.KRW.value {           /// 지불 방식: KRW
            tickerKRWList.value[currentName] = setKRWTableData(symbol: "\(currentName)",
                                         currentPrice: tickerInfo.closePrice,
                                         changeRate: tickerInfo.chgRate,
                                         changeAmount: tickerInfo.chgAmt,
                                         transactionAmount: tickerInfo.value,
                                         volumePower: tickerInfo.volumePower)
        } else if payment == PaymentCurrency.BTC.value {    /// 지불 방식: BTC]
            tickerBTCList.value[currentName] = setBTCTableData(symbol: "\(currentName)",
                                         currentPrice: tickerInfo.closePrice,
                                         changeRate: tickerInfo.chgRate,
                                         transactionAmount: tickerInfo.value,
                                         volumePower: tickerInfo.volumePower)
        }
    }
    
    func setInterestList(_ completion: @escaping () -> ()) {
        let interestData = realm.objects(InterestCurrency.self)
        
        tabInterestList = interestData.filter { interestInfo in
            interestInfo.interest == true
        }.map { interestInfo in
            let splitedSymbol: [String] = interestInfo.currency.split(separator: "_").map { "\($0)" }
            let currentName = splitedSymbol[0]
            let payment = splitedSymbol[1]
            return (currentName, PaymentCurrency.init(rawValue: payment) ?? .KRW)
        }
        completion()
    }
    
    func setInterestData(interest: InterestCurrency) {
        try! realm.write {
            realm.add(interest, update: .modified)
        }
    }

    func isInterest(interestKey: String) -> Bool {
        let interestData = realm.objects(InterestCurrency.self)
        return !interestData.filter { interestInfo in
            return interestInfo.currency == interestKey && interestInfo.interest == true
        }.isEmpty
    }
    
    @objc
    func sortCurrentTabList() {
        switch currentTab {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            tabPopularList = Array(tabKRWList.sorted {
                guard let frontVolumPower = tickerKRWList.value[$0.0]?.volumePower.doubleValue,
                      let backVolumPower = tickerKRWList.value[$1.0]?.volumePower.doubleValue else {
                          return true
                      }
                return frontVolumPower > backVolumPower
            }[0..<5])
            currentList.value = tabPopularList
        default:
            break
        }
    }
    
    // MARK: - Private Func
    func chageCurrentTab(_ currentTab: Int) {
        self.currentTab = currentTab
        
        switch currentTab {
        case 0:
            currentList.value = tabKRWList
        case 1:
            currentList.value = tabBTCList
        case 2:
            setInterestList() { [weak self] in
                guard let self = self else { return }
                self.currentList.value = self.tabInterestList
            }
        default:
            break
        }
        
        /// 인기 리스트는 한번만 리스트가 세팅되지 않고 10초마다 한번씩 체결강도따라 리스트가 바뀜
        if currentTab == 3 {
            sortCurrentTabList()
            startTimer(interval: 10)
        } else {
            stopTimer()
        }
    }
    
    /// currentTab을 직접 세팅되지 않게하기 위함
    func getCurrentTab() -> Int {
        return currentTab
    }
    
    private func setKRWInitialData(_ completion: @escaping () -> ()) {
        let paymentCurrency: PaymentCurrency = .KRW
        apiManager.fetchTicker(paymentCurrency: paymentCurrency) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.currentInfo.current
                var tickerKRWList: [String: CrypotocurrencyKRWListTableViewEntity] = [:]
                var currencyNameList: [(String, PaymentCurrency)] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let tableData = self.setKRWTableData(symbol: tickerInfo.currentName ?? "",
                                                      currentPrice: tickerInfo.closingPrice ?? "",
                                                      changeRate: tickerInfo.fluctateRate24H ?? "",
                                                      changeAmount: tickerInfo.fluctate24H ?? "",
                                                      transactionAmount: tickerInfo.accTradeValue ?? "",
                                                      volumePower: "")
                    currencyNameList.append((currentName, PaymentCurrency.KRW))
                    tickerKRWList[currentName] = tableData
                }
                self.tickerKRWList.value = tickerKRWList
                self.tabKRWList = currencyNameList
                completion()
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
                completion()
            }
        }
    }
    
    private func setBTCInitialData(_ completion: @escaping () -> ()) {
        let paymentCurrency: PaymentCurrency = .BTC
        apiManager.fetchTicker(paymentCurrency: paymentCurrency) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.currentInfo.current
                var tickerBTCList: [String: CrypotocurrencyBTCListTableViewEntity] = [:]
                var currencyNameList: [(String, PaymentCurrency)] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let tableData = self.setBTCTableData(symbol: tickerInfo.currentName ?? "",
                                                      currentPrice: tickerInfo.closingPrice ?? "",
                                                      changeRate: tickerInfo.fluctateRate24H ?? "",
                                                      transactionAmount: tickerInfo.accTradeValue ?? "",
                                                      volumePower: "")
                    currencyNameList.append((currentName, PaymentCurrency.BTC))
                    tickerBTCList[currentName] = tableData
                }
                self.tickerBTCList.value = tickerBTCList
                self.tabBTCList = currencyNameList
                completion()
            case .failure(let error):
                self.delegate?.showAlert(message: error.debugDescription)
                completion()
            }
        }
    }
    
    private func setKRWTableData(symbol: String,
                                 currentPrice: String,
                                 changeRate: String,
                                 changeAmount: String,
                                 transactionAmount: String,
                                 volumePower: String) -> CrypotocurrencyKRWListTableViewEntity {
        let currentPrice: String = currentPrice.setNumStringForm(isDecimalType: true)
        let changeRate: String = "\(changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let changeAmount: String = changeAmount.setNumStringForm(isDecimalType: true, isMarkPlusMiuns: true)
        let transactionAmount: String = "\(Int((transactionAmount.doubleValue ?? 0) / 1000000).decimalType ?? "")백만"
        
        return CrypotocurrencyKRWListTableViewEntity(symbol: symbol,
                                                  currentPrice: currentPrice,
                                                  changeRate: changeRate,
                                                  changeAmount: changeAmount,
                                                  transactionAmount: transactionAmount,
                                                  volumePower: volumePower)
    }
    
    private func setBTCTableData(symbol: String,
                                 currentPrice: String,
                                 changeRate: String,
                                 transactionAmount: String,
                                 volumePower: String) -> CrypotocurrencyBTCListTableViewEntity {
        let currentPrice: String = currentPrice.displayDecimal(to: 8)
        let changeRate: String = changeRate == "" ? "0.00%" : "\(changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let transactionAmount: String = transactionAmount.displayDecimal(to: 3)
        
        return CrypotocurrencyBTCListTableViewEntity(symbol: symbol,
                                                  currentPrice: currentPrice,
                                                  changeRate: changeRate,
                                                  transactionAmount: transactionAmount,
                                                  volumePower: volumePower)
    }
    
    private func startTimer(interval: Double) {
        if(timeTrigger) {
            timer = Timer.scheduledTimer(timeInterval: interval,
                                         target: self,
                                         selector: #selector(sortCurrentTabList),
                                         userInfo: nil,
                                         repeats: true)
            timeTrigger = false
        }
    }
    
    private func stopTimer() {
        timeTrigger = true
        timer.invalidate()
    }
}
