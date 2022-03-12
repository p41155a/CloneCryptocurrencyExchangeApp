//
//  CryptocurrencyListModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/09.
//

import Foundation
import RealmSwift

class CryptocurrencyListModel {
    var tickerKRWList: [String: CryptocurrencyListTableViewEntity] = [:]
    var tickerBTCList: [String: CryptocurrencyListTableViewEntity] = [:]
    var tabKRWList: [CryptocurrencySymbolInfo] = []
    var tabBTCList: [CryptocurrencySymbolInfo] = []
    var tabInterestList: [CryptocurrencySymbolInfo] = []
    var tabPopularList: [CryptocurrencySymbolInfo] = []
    var sortInfo: SortInfo = SortInfo()
    var searchWord: String = ""
    
    // MARK: about websocket
    func getSymbols(for payment: PaymentCurrency) -> [String] {
        switch payment {
        case .KRW:
            return tabKRWList.map {
                "\($0.order)_KRW"
            }
        case .BTC:
            return tabBTCList.map {
                "\($0.order)_BTC"
            }
        }
    }
    
    func setWebSocketData(order: String,
                          payment: PaymentCurrency,
                          tickerInfo: WebSocketTickerContent) {
        tickerKRWList[order] = CryptocurrencyListTableViewEntity(order: order,
                                                                 payment: payment,
                                                                 currentPrice: tickerInfo.closePrice.doubleValue ?? 0,
                                                                 changeRate: tickerInfo.chgRate.doubleValue ?? 0,
                                                                 changeAmount: tickerInfo.chgAmt,
                                                                 transactionAmount: tickerInfo.value.doubleValue ?? 0,
                                                                 volumePower: tickerInfo.volumePower)
    }
    
    func getCurrentList(for tab: MainListCurrentTab) -> [CryptocurrencySymbolInfo] {
        let searchedList = getSearchedList(for: tab, word: searchWord)
        return sortList(list: searchedList)
    }
    
    // MARK: about Interest
    func setInterestList(from data: [InterestCurrency]) {
        tabInterestList = data.map { interestInfo -> CryptocurrencySymbolInfo in
            let splitedSymbol: [String] = interestInfo.currency.split(separator: "_").map { "\($0)" }
            let order = splitedSymbol[0]
            let payment = splitedSymbol[1]
            return CryptocurrencySymbolInfo(order: order,
                                            payment: .init(rawValue: payment) ?? .KRW)
        }
    }
    
    // MARK: about Popular
    func setTabPopularList() {
        tabPopularList = Array(tabKRWList.sorted {
            guard let frontVolumPower = tickerKRWList[$0.order]?.volumePower.doubleValue,
                  let backVolumPower = tickerKRWList[$1.order]?.volumePower.doubleValue else {
                      return true
                  }
            return frontVolumPower > backVolumPower
        }[0..<5])
    }
    
    func setAPIData(tickerList: [String: CryptocurrencyListTableViewEntity],
                    symbolsList: [CryptocurrencySymbolInfo],
                    payment: PaymentCurrency,
                    _ completion: @escaping () -> ()) {
        switch payment {
        case .KRW:
            self.tickerKRWList = tickerList
            self.tabKRWList = symbolsList
        case .BTC:
            self.tickerBTCList = tickerList
            self.tabBTCList = symbolsList
        }
        completion()
    }
    
    func getEachPaymentList(for payment: PaymentCurrency) -> [String: CryptocurrencyListTableViewEntity] {
        switch payment {
        case .KRW:
            return tickerKRWList
        case .BTC:
            return tickerBTCList
        }
    }
    
    // MARK: - Private Func
    private func getSearchedList(for tab: MainListCurrentTab,
                         word: String) -> [CryptocurrencySymbolInfo] {
        return getCurrentTabList(for: tab).filter {
            word == "" ? true : $0.order.lowercased().contains(word.lowercased())
        }
    }
    
    private func getCurrentTabList(for tab: MainListCurrentTab) -> [CryptocurrencySymbolInfo] {
        switch tab {
        case .tabKRW:
            return tabKRWList
        case .tabBTC:
            return tabBTCList
        case .tabInterest:
            return tabInterestList
        default:
            return tabPopularList
        }
    }
    
    private func sortList(list: [CryptocurrencySymbolInfo]) -> [CryptocurrencySymbolInfo] {
        return list.sorted {
            let frontData = getEachPaymentList(for: $0.payment)[$0.order]
            let backData = getEachPaymentList(for: $1.payment)[$1.order]
            switch sortInfo.standard {
            case .currencyName:
                return order(orderBy: sortInfo.orderby,
                             frontData: $0.order,
                             backData: $1.order)
            case .currentPrice:
                guard let frontCurrentPrice = frontData?.currentPrice,
                      let backCurrentPrice = backData?.currentPrice else {
                          return true
                      }
                return order(orderBy: sortInfo.orderby,
                             frontData: frontCurrentPrice,
                             backData: backCurrentPrice)
            case .changeRate:
                guard let frontChangeRate = frontData?.changeRate,
                      let backChangeRate = backData?.changeRate else {
                          return true
                      }
                return order(orderBy: sortInfo.orderby,
                             frontData: frontChangeRate,
                             backData: backChangeRate)
            case .transaction:
                guard let frontTransactionAmount = frontData?.transactionAmount,
                      let backTransactionAmount = backData?.transactionAmount else {
                          return true
                      }
                return order(orderBy: sortInfo.orderby,
                             frontData: frontTransactionAmount,
                             backData: backTransactionAmount)
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
}
