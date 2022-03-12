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
    var model = CryptocurrencyListModel()
    var nibName: String?
    private var timeTrigger = true
    private var timer = Timer()
    private var apiManager = TickerAPIManager()
    private var interestDB = InterestDBManager()
    private var socketManager = AllTickerWebSocketManager()
    private var sortDB = SortDBManager()
    private var currentTab: MainListCurrentTab = .tabKRW
    let currentList: Observable<[CryptocurrencySymbolInfo]> = Observable([])
    let changeIndex: Observable<Int> = Observable(0)
    let error: Observable<String?> = Observable(nil)
    
    // MARK: - init
    init(nibName: String? = nil) {
        self.nibName = nibName
        socketManager.delegate = self
    }
    
    // MARK: - Func
    // MARK: 초기 데이터 설정
    func setInitialData() {
        model.sortInfo = getSortInfo()
        setInitialDataForPayment(payment: PaymentCurrency.KRW) { [weak self] in
            guard let self = self else { return }
            self.currentList.value = self.model.getCurrentList(for: self.currentTab)
            self.socketManager.symbolsKRW = self.getSymbols(for: .KRW)
        }
        setInitialDataForPayment(payment: PaymentCurrency.BTC) { [weak self] in
            self?.socketManager.symbolsBTC = self?.getSymbols(for: .BTC) ?? []
        }
    }
    
    // MARK: For tableView
    func getTableViewEntity(for info: CryptocurrencySymbolInfo) -> CryptocurrencyListTableViewEntity {
        let list = self.model.getEachPaymentList(for: info.payment)
        return list[info.order] ?? CryptocurrencyListTableViewEntity()
    }
    
    // MARK: about Interest
    func setInterestData(of symbolInfo: CryptocurrencySymbolInfo, isInterest: Bool) {
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
    
    func isInterest(of symbolInfo: CryptocurrencySymbolInfo) -> Bool {
        return interestDB.isInterest(of: symbolInfo)
    }
    
    // MARK: select tab
    func chageCurrentTab(_ currentTab: Int) {
        self.currentTab = MainListCurrentTab.init(rawValue: currentTab) ?? .tabKRW
        switch self.currentTab {
        case .tabKRW:
            stopTimer()
            currentList.value = model.getCurrentList(for: self.currentTab)
        case .tabBTC:
            stopTimer()
            currentList.value = model.getCurrentList(for: self.currentTab)
        case .tabInterest:
            stopTimer()
            setInterestList() { [weak self] in
                self?.currentList.value = self?.model.getCurrentList(
                    for: self?.currentTab ?? .tabKRW
                ) ?? []
            }
        case .tabPopular:
            sortByVolumePower()
            startTimer(interval: 10)
        }
    }
    
    /// currentTab을 직접 세팅되지 않게하기 위함
    func getCurrentTab() -> Int {
        return currentTab.rawValue
    }
    
    // MARK: about sort
    func sortCurrentTabList(by sortInfo: SortInfo) {
        saveSortInfo(sortInfo: sortInfo) { [weak self] in
            self?.model.sortInfo = sortInfo
            self?.currentList.value = self?.model.getCurrentList(
                for: self?.currentTab ?? .tabKRW
            ) ?? []
        }
    }
    
    func searchCurrency(by word: String) {
        model.searchWord = word
        currentList.value = model.getCurrentList(for: currentTab)
    }
    
    func getSortInfo() -> SortInfo {
        return sortDB.existingData() ?? SortInfo(standard: .transaction, orderby: .desc)
    }
    
    func getExplainEmpty() -> String {
        guard model.searchWord != "" else {
            return "등록된 관심 가상자산이 없습니다."
        }
        return "조건에 맞는 암호화폐가 없습니다."
    }
    
    // MARK: - Private Func
    // MARK: about sort <private>
    private func saveSortInfo(sortInfo: SortInfo, completion: @escaping () -> ()) {
        sortDB.add(sortInfo: sortInfo) { [weak self] result in
            switch result {
            case .success(_):
                completion()
            case .failure(_):
                self?.error.value = "DB를 불러오지 못하였습니다.\n앱을 제거 후 다시 설치해주세요"
                completion()
            }
        }
    }
    
    @objc
    private func sortByVolumePower() {
        model.setTabPopularList()
        currentList.value = model.getCurrentList(for: .tabPopular)
    }
    
    // MARK: about Interest <private>
    private func setInterestList(_ completion: @escaping () -> ()) {
        interestDB.existingData() { interestData in
            self.model.setInterestList(from: interestData)
            completion()
        }
    }
    
    // MARK: 초기 데이터 설정 <private>
    private func setInitialDataForPayment(payment: PaymentCurrency, _ completion: @escaping () -> ()) {
        apiManager.fetchTicker(paymentCurrency: payment) { result in
            switch result {
            case .success(let data):
                let cryptocurrencyData = data.ordersInfo.orderInfo
                var tickerList: [String: CryptocurrencyListTableViewEntity] = [:]
                var symbolsList: [CryptocurrencySymbolInfo] = []
                cryptocurrencyData.forEach { data in
                    let order = data.key
                    let tickerInfo = data.value
                    let paymentInfo = CryptocurrencySymbolInfo(order: order,
                                                               payment: payment)
                    let tableData = CryptocurrencyListTableViewEntity(
                        order: tickerInfo.currentName ?? "",
                        payment: payment,
                        currentPrice: tickerInfo.closingPrice?.doubleValue ?? 0,
                        changeRate: tickerInfo.fluctateRate24H?.doubleValue ?? 0,
                        changeAmount: tickerInfo.fluctate24H ?? "",
                        transactionAmount: tickerInfo.accTradeValue24H?.doubleValue ?? 0,
                        volumePower: ""
                    )
                    symbolsList.append(paymentInfo)
                    tickerList[order] = tableData
                }
                self.model.setAPIData(tickerList: tickerList,
                                      symbolsList: symbolsList,
                                      payment: payment) {
                    completion()
                }
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
}
extension CryptocurrencyListViewModel: AllTickerWebSocketManagerDelegate {
    func handingError(for error: String) {
        self.error.value = error
    }
    
    func setWebSocketData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        let splitedSymbol: [String] = tickerInfo.symbol.split(separator: "_").map { "\($0)" }
        let order = splitedSymbol[0]
        let payment = splitedSymbol[1]
        
        for (index, paymentInfo) in currentList.value.enumerated() {
            if paymentInfo.order == order {
                changeIndex.value = index
            }
        }
        
        model.setWebSocketData(order: order,
                               payment: PaymentCurrency(rawValue: payment) ?? .KRW,
                               tickerInfo: tickerInfo)
    }
    
    func connectSocket() {
        socketManager.connect()
    }
    
    func disconnectSocket() {
        socketManager.disconnect()
    }
    
    func getSymbols(for payment: PaymentCurrency) -> [String] {
        return model.getSymbols(for: payment)
    }
}
