//
//  CryptocurrencyListViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import Foundation
import RealmSwift

final class CryptocurrencyListViewModel: XIBInformation {
    // MARK: - Property
    private var timeTrigger = true
    private var timer = Timer()
    private let realm: Realm
    private var apiManager = TickerAPIManager()
    var nibName: String?
    /// Property about data
    var tickerKRWList: [String: CryptocurrencyListTableViewEntity] = [:]
    var tickerBTCList: [String: CryptocurrencyListTableViewEntity] = [:]
    var tabKRWList: [CryptocurrencyPaymentInfo] = []
    var tabBTCList: [CryptocurrencyPaymentInfo] = []
    var tabInterestList: [CryptocurrencyPaymentInfo] = []
    var tabPopularList: [CryptocurrencyPaymentInfo] = []
    let currentList: Observable<[CryptocurrencyPaymentInfo]> = Observable([])
    private var currentTab: CurrentTab = .tabKRW
    private var searchWord: String = ""
    let changeIndex: Observable<Int> = Observable(0)
    let error: Observable<String?> = Observable(nil)
    
    // MARK: - init
    init(nibName: String? = nil) {
        self.nibName = nibName
        realm = try! Realm()
    }
    
    // MARK: - Func
    // MARK: 초기 데이터 설정
    func setInitialData() {
        setBTCInitialData() {}
        setKRWInitialData() { [weak self] in
            guard let self = self else { return }
            self.currentList.value = self.tabKRWList
        }
    }
    
    func getSymbols(for payment: PaymentCurrency) -> [String] {
        switch payment {
        case .KRW:
            return tabKRWList.map {
                "\($0.currencyName)_KRW"
            }
        case .BTC:
            return tabBTCList.map {
                "\($0.currencyName)_BTC"
            }
        }
    }
    
    // MARK: WebSocket 데이터 설정
    func setWebSocketData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        let splitedSymbol: [String] = tickerInfo.symbol.split(separator: "_").map { "\($0)" }
        let currencyName = splitedSymbol[0]
        let payment = splitedSymbol[1]
        
        /// 변경된 값이 현재 탭에 있는 값일때
        for (index, paymentInfo) in currentList.value.enumerated() {
            if paymentInfo.currencyName == currencyName {
                changeIndex.value = index
            }
        }
        
        tickerKRWList[currencyName] = CryptocurrencyListTableViewEntity(symbol: currencyName,
                                                                             payment: PaymentCurrency(rawValue: payment) ?? .KRW,
                                                                             currentPrice: tickerInfo.closePrice.doubleValue ?? 0,
                                                                             changeRate: tickerInfo.chgRate.doubleValue ?? 0,
                                                                             changeAmount: tickerInfo.chgAmt,
                                                                             transactionAmount: tickerInfo.value.doubleValue ?? 0,
                                                                             volumePower: tickerInfo.volumePower)
    }
    
    // MARK: about Interest
    func setInterestList(_ completion: @escaping () -> ()) {
        let interestData = realm.objects(InterestCurrency.self)
        
        tabInterestList = interestData.filter { interestInfo in
            interestInfo.interest == true
        }.map { interestInfo in
            let splitedSymbol: [String] = interestInfo.currency.split(separator: "_").map { "\($0)" }
            let currentName = splitedSymbol[0]
            let payment = splitedSymbol[1]
            return CryptocurrencyPaymentInfo(currencyName: currentName,
                                             payment: .init(rawValue: payment) ?? .KRW)
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
    
    // MARK: select tab
    func chageCurrentTab(_ currentTab: Int) {
        self.currentTab = CurrentTab.init(rawValue: currentTab) ?? .tabKRW
        
        switch currentTab {
        case 0, 1:
            searchCurrency(for: self.searchWord)
        case 2:
            setInterestList() { [weak self] in
                guard let self = self else { return }
                self.searchCurrency(for: self.searchWord)
            }
        default:
            break
        }
        
        /// 인기 리스트는 한번만 리스트가 세팅되지 않고 10초마다 한번씩 체결강도따라 리스트가 바뀜
        if currentTab == 3 {
            sortByVolumePower()
            startTimer(interval: 10)
        } else {
            stopTimer()
        }
    }
    
    /// currentTab을 직접 세팅되지 않게하기 위함
    func getCurrentTab() -> Int {
        return currentTab.rawValue
    }
    
    // MARK: about sort
    @objc
    func sortByVolumePower() {
        tabPopularList = Array(tabKRWList.sorted {
            guard let frontVolumPower = tickerKRWList[$0.currencyName]?.volumePower.doubleValue,
                  let backVolumPower = tickerKRWList[$1.currencyName]?.volumePower.doubleValue else {
                      return true
                  }
            return frontVolumPower > backVolumPower
        }[0..<5])
        searchCurrency(for: self.searchWord)
    }
    
    func sortCurrentTabList(orderBy: OrderBy, standard: MainListSortStandard) {
        let sortInfo = SortInfo(standard: standard, orderby: orderBy)
        saveSortInfo(sortInfo: sortInfo)
        currentList.value = sortList(orderBy: orderBy, standard: standard, list: currentList.value)
    }
    
    // MARK: Search
    func searchCurrency(for word: String) {
        searchWord = word
        switch currentTab {
        case .tabKRW:
            currentList.value = tabKRWList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        case .tabBTC:
            currentList.value = tabBTCList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        case .tabInterest:
            currentList.value = tabInterestList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        default:
            currentList.value = tabPopularList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        }
    }
    
    // MARK: - Private Func
    // MARK: about sort <private>
    private func saveSortInfo(sortInfo: SortInfo) {
        try! realm.write {
            realm.add(sortInfo, update: .modified)
        }
    }
    
    func getSortInfo() -> SortInfo {
        return realm.objects(SortInfo.self).first ?? SortInfo(standard: .transaction, orderby: .desc)
    }
    
    private func sortList(orderBy: OrderBy, standard: MainListSortStandard, list: [CryptocurrencyPaymentInfo]) -> [CryptocurrencyPaymentInfo] {
        return list.sorted {
            let frontData = $0.payment == .KRW ? tickerKRWList[$0.currencyName] : tickerBTCList[$0.currencyName]
            let backData = $0.payment == .KRW ? tickerKRWList[$1.currencyName] : tickerBTCList[$1.currencyName]
            switch standard {
            case .currencyName:
                return order(orderBy: orderBy, frontData: $0.currencyName, backData: $1.currencyName)
            case .currentPrice:
                guard let frontCurrentPrice = frontData?.currentPrice,
                      let backCurrentPrice = backData?.currentPrice else {
                          return true
                      }
                return order(orderBy: orderBy, frontData: frontCurrentPrice, backData: backCurrentPrice)
            case .changeRate:
                guard let frontChangeRate = frontData?.changeRate,
                      let backChangeRate = backData?.changeRate else {
                          return true
                      }
                return order(orderBy: orderBy, frontData: frontChangeRate, backData: backChangeRate)
            case .transaction:
                guard let frontTransactionAmount = frontData?.transactionAmount,
                      let backTransactionAmount = backData?.transactionAmount else {
                          return true
                      }
                return order(orderBy: orderBy, frontData: frontTransactionAmount, backData: backTransactionAmount)
            }
        }
    }
    
    private func order<T: Comparable>(orderBy: OrderBy, frontData: T, backData: T) -> Bool {
        switch orderBy {
        case .asc:
            return frontData < backData
        case .desc:
            return frontData > backData
        }
    }
    
    // MARK: 초기 데이터 설정 <private>
    private func setKRWInitialData(_ completion: @escaping () -> ()) {
        let paymentCurrency: PaymentCurrency = .KRW
        apiManager.fetchTicker(paymentCurrency: paymentCurrency) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.currentInfo.current
                var tickerKRWList: [String: CryptocurrencyListTableViewEntity] = [:]
                var currencyNameList: [CryptocurrencyPaymentInfo] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let paymentInfo = CryptocurrencyPaymentInfo(currencyName: currentName,
                                                                payment: paymentCurrency)
                    let tableData = CryptocurrencyListTableViewEntity(symbol: tickerInfo.currentName ?? "",
                                                                      payment: paymentCurrency,
                                                                      currentPrice: tickerInfo.closingPrice?.doubleValue ?? 0,
                                                                      changeRate: tickerInfo.fluctateRate24H?.doubleValue ?? 0,
                                                                      changeAmount: tickerInfo.fluctate24H ?? "",
                                                                      transactionAmount: tickerInfo.accTradeValue?.doubleValue ?? 0,
                                                                      volumePower: "")
                    currencyNameList.append(paymentInfo)
                    tickerKRWList[currentName] = tableData
                }
                let sortInfo = self.getSortInfo()
                self.tickerKRWList = tickerKRWList
                self.tabKRWList = self.sortList(orderBy: sortInfo.orderby,
                                                standard: sortInfo.standard,
                                                list: currencyNameList)
                completion()
            case .failure(let error):
                self.error.value = error.debugDescription
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
                var tickerBTCList: [String: CryptocurrencyListTableViewEntity] = [:]
                var currencyNameList: [CryptocurrencyPaymentInfo] = []
                cryptocurrencyData.forEach { data in
                    let currentName = data.key
                    let tickerInfo = data.value
                    let paymentInfo = CryptocurrencyPaymentInfo(currencyName: currentName,
                                                                payment: paymentCurrency)
                    let tableData = CryptocurrencyListTableViewEntity(symbol: tickerInfo.currentName ?? "",
                                                                      payment: paymentCurrency,
                                                                      currentPrice: tickerInfo.closingPrice?.doubleValue ?? 0,
                                                                      changeRate: tickerInfo.fluctateRate24H?.doubleValue ?? 0,
                                                                      transactionAmount: tickerInfo.accTradeValue?.doubleValue ?? 0,
                                                                      volumePower: "")
                    currencyNameList.append(paymentInfo)
                    tickerBTCList[currentName] = tableData
                }
                let sortInfo = self.getSortInfo()
                self.tickerBTCList = tickerBTCList
                self.tabBTCList = self.sortList(orderBy: sortInfo.orderby,
                                                standard: sortInfo.standard,
                                                list: currencyNameList)
                completion()
            case .failure(let error):
                self.error.value = error.debugDescription
                completion()
            }
        }
    }
    
    // MARK: about Interest <timer 설정>
    private func startTimer(interval: Double) {
        if(timeTrigger) {
            timer = Timer.scheduledTimer(timeInterval: interval,
                                         target: self,
                                         selector: #selector(sortByVolumePower),
                                         userInfo: nil,
                                         repeats: true)
            timeTrigger = false
        }
    }
    
    private func stopTimer() {
        timeTrigger = true
        timer.invalidate()
    }
    
    enum CurrentTab: Int {
        case tabKRW = 0
        case tabBTC = 1
        case tabInterest = 2
        case tabPopular = 3
    }
}
