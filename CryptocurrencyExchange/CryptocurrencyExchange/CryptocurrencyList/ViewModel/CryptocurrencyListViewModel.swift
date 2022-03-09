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
    private let realm: Realm
    private var apiManager = TickerAPIManager()
    private var currentTab: MainListCurrentTab = .tabKRW
    private var searchWord: String = ""
    let currentList: Observable<[CryptocurrencySymbolInfo]> = Observable([])
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
        setInitialData(payment: PaymentCurrency.KRW) { [weak self] in
            guard let self = self else { return }
            self.currentList.value = self.model.tabKRWList}
        setInitialData(payment: PaymentCurrency.BTC) {}
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
        
        model.setWebSocketData(order: order, payment: PaymentCurrency(rawValue: payment) ?? .KRW, tickerInfo: tickerInfo)
    }
    
    // MARK: about Interest
    func setInterestList() {
        let interestData = realm.objects(InterestCurrency.self)
        model.setInterestList(from: interestData)
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
        self.currentTab = MainListCurrentTab.init(rawValue: currentTab) ?? .tabKRW
        
        switch currentTab {
        case 0, 1:
            searchCurrency(for: self.searchWord)
        case 2:
            setInterestList()
            searchCurrency(for: self.searchWord)
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
        model.setTabPopularList()
        searchCurrency(for: self.searchWord)
    }
    
    func sortCurrentTabList(orderBy: OrderBy, standard: MainListSortStandard) {
        let sortInfo = SortInfo(standard: standard, orderby: orderBy)
        saveSortInfo(sortInfo: sortInfo)
        currentList.value = model.sortList(orderBy: orderBy, standard: standard, list: currentList.value)
    }
    
    // MARK: Search
    func searchCurrency(for word: String) {
        searchWord = word
        currentList.value = model.getSearchedList(for: currentTab, word: word)
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
    
    // MARK: 초기 데이터 설정 <private>
    private func setInitialData(payment: PaymentCurrency ,_ completion: @escaping () -> ()) {
        apiManager.fetchTicker(paymentCurrency: payment) { result in
            switch result {
            case .success(let data):
                self.model.setAPIData(of: data, payment: payment, sortInfo: self.getSortInfo()) {
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
