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
    private var sortDB = SortDBManager()
    private var currentTab: MainListCurrentTab = .tabKRW
    private var searchWord: String = ""
    let currentList: Observable<[CryptocurrencySymbolInfo]> = Observable([])
    let changeIndex: Observable<Int> = Observable(0)
    let error: Observable<String?> = Observable(nil)
    
    // MARK: - init
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
    
    // MARK: - Func
    // MARK: 초기 데이터 설정
    func setInitialData() {
        setInitialDataForPayment(payment: PaymentCurrency.KRW) { [weak self] in
            guard let self = self else { return }
            self.currentList.value = self.model.tabKRWList}
        setInitialDataForPayment(payment: PaymentCurrency.BTC) {}
    }
    
    // MARK: For tableView
    func getTableViewEntity(for info: CryptocurrencySymbolInfo) -> CryptocurrencyListTableViewEntity {
        var result: CryptocurrencyListTableViewEntity?
        switch info.payment {
        case .KRW:
            result = self.model.tickerKRWList[info.order]
        case .BTC:
            result = self.model.tickerBTCList[info.order]
        }
        return result ?? CryptocurrencyListTableViewEntity()
    }
    
    // MARK: about websocket
    func getSymbols(for payment: PaymentCurrency) -> [String] {
        return model.getSymbols(for: payment)
    }
    
    func setWebSocketData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        let splitedSymbol: [String] = tickerInfo.symbol.split(separator: "_").map { "\($0)" }
        let order = splitedSymbol[0]
        let payment = splitedSymbol[1]
        
        /// 변경된 값이 현재 탭에 있는 값일때
        for (index, paymentInfo) in currentList.value.enumerated() {
            if paymentInfo.order == order {
                changeIndex.value = index
            }
        }
        
        model.setWebSocketData(order: order,
                               payment: PaymentCurrency(rawValue: payment) ?? .KRW,
                               tickerInfo: tickerInfo)
    }
    
    // MARK: about Interest
    func setInterestData(interest: InterestCurrency) {
        return interestDB.add(interest: interest)
    }
    
    func isInterest(of interestKey: String) -> Bool {
        return interestDB.isInterest(of: interestKey)
    }
    
    // MARK: select tab
    func chageCurrentTab(_ currentTab: Int) {
        self.currentTab = MainListCurrentTab.init(rawValue: currentTab) ?? .tabKRW
        switch self.currentTab {
        case .tabKRW:
            stopTimer()
            searchCurrency(for: self.searchWord)
        case .tabBTC:
            stopTimer()
            searchCurrency(for: self.searchWord)
        case .tabInterest:
            stopTimer()
            setInterestList()
            searchCurrency(for: self.searchWord)
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
    @objc
    func sortByVolumePower() {
        model.setTabPopularList()
        searchCurrency(for: self.searchWord)
    }
    
    func sortCurrentTabList(orderBy: OrderBy, standard: MainListSortStandard) {
        let sortInfo = SortInfo(standard: standard,
                                orderby: orderBy)
        saveSortInfo(sortInfo: sortInfo)
        currentList.value = model.sortList(orderBy: orderBy,
                                           standard: standard,
                                           list: currentList.value)
    }
    
    // MARK: Search
    func searchCurrency(for word: String) {
        searchWord = word
        currentList.value = model.getSearchedList(for: currentTab, word: word)
    }
    
    // MARK: - Private Func
    // MARK: about sort <private>
    private func saveSortInfo(sortInfo: SortInfo) {
        sortDB.add(sortInfo: sortInfo)
    }
    
    func getSortInfo() -> SortInfo {
        return sortDB.existingData() ?? SortInfo(standard: .transaction, orderby: .desc)
    }
    
    // MARK: about Interest <private>
    private func setInterestList() {
        interestDB.existingData() { interestData in
            self.model.setInterestList(from: interestData)
        }
    }
    
    // MARK: 초기 데이터 설정 <private>
    private func setInitialDataForPayment(payment: PaymentCurrency ,_ completion: @escaping () -> ()) {
        apiManager.fetchTicker(paymentCurrency: payment) { result in
            switch result {
            case .success(let data):
                self.model.setAPIData(of: data,
                                      payment: payment,
                                      sortInfo: self.getSortInfo()) {
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
