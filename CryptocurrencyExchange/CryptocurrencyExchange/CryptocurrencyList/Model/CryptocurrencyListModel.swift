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
    var tabKRWList: [CryptocurrencyPaymentInfo] = []
    var tabBTCList: [CryptocurrencyPaymentInfo] = []
    var tabInterestList: [CryptocurrencyPaymentInfo] = []
    var tabPopularList: [CryptocurrencyPaymentInfo] = []
    
    // MARK: about websocket
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
    
    func setWebSocketData(symbol: String, payment: PaymentCurrency, tickerInfo: WebSocketTickerContent) {
        tickerKRWList[symbol] = CryptocurrencyListTableViewEntity(order: symbol,
                                                                             payment: payment,
                                                                             currentPrice: tickerInfo.closePrice.doubleValue ?? 0,
                                                                             changeRate: tickerInfo.chgRate.doubleValue ?? 0,
                                                                             changeAmount: tickerInfo.chgAmt,
                                                                             transactionAmount: tickerInfo.value.doubleValue ?? 0,
                                                                             volumePower: tickerInfo.volumePower)
    }
    
    // MARK: about Interest
    func setInterestList(from data: Results<InterestCurrency>) {
        tabInterestList = data.filter { interestInfo in
            interestInfo.interest == true
        }.map { interestInfo in
            let splitedSymbol: [String] = interestInfo.currency.split(separator: "_").map { "\($0)" }
            let currentName = splitedSymbol[0]
            let payment = splitedSymbol[1]
            return CryptocurrencyPaymentInfo(currencyName: currentName,
                                             payment: .init(rawValue: payment) ?? .KRW)
        }
    }
    
    // MARK: about Popular
    func setTabPopularList() {
        tabPopularList = Array(tabKRWList.sorted {
            guard let frontVolumPower = tickerKRWList[$0.currencyName]?.volumePower.doubleValue,
                  let backVolumPower = tickerKRWList[$1.currencyName]?.volumePower.doubleValue else {
                      return true
                  }
            return frontVolumPower > backVolumPower
        }[0..<5])
    }
    
    func getSearchedList(for tap: MainListCurrentTab, word: String) -> [CryptocurrencyPaymentInfo] {
        switch tap {
        case .tabKRW:
            return tabKRWList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        case .tabBTC:
            return tabBTCList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        case .tabInterest:
            return tabInterestList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        default:
            return tabPopularList.filter { word == "" ? true : $0.currencyName.lowercased().contains(word.lowercased()) }
        }
    }
    
    func sortList(orderBy: OrderBy, standard: MainListSortStandard, list: [CryptocurrencyPaymentInfo]) -> [CryptocurrencyPaymentInfo] {
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
    
    func setAPIData(of data: TickerEntity, payment: PaymentCurrency, sortInfo: SortInfo, _ completion: @escaping () -> ()) {
        let cryptocurrencyData = data.currentInfo.current
        var tickerList: [String: CryptocurrencyListTableViewEntity] = [:]
        var currencyNameList: [CryptocurrencyPaymentInfo] = []
        cryptocurrencyData.forEach { data in
            let currentName = data.key
            let tickerInfo = data.value
            let paymentInfo = CryptocurrencyPaymentInfo(currencyName: currentName,
                                                        payment: payment)
            let tableData = CryptocurrencyListTableViewEntity(order: tickerInfo.currentName ?? "",
                                                              payment: payment,
                                                              currentPrice: tickerInfo.closingPrice?.doubleValue ?? 0,
                                                              changeRate: tickerInfo.fluctateRate24H?.doubleValue ?? 0,
                                                              changeAmount: tickerInfo.fluctate24H ?? "",
                                                              transactionAmount: tickerInfo.accTradeValue?.doubleValue ?? 0,
                                                              volumePower: "")
            currencyNameList.append(paymentInfo)
            tickerList[currentName] = tableData
        }
        
        switch payment {
        case .KRW:
            self.tickerKRWList = tickerList
            self.tabKRWList = self.sortList(orderBy: sortInfo.orderby,
                                            standard: sortInfo.standard,
                                            list: currencyNameList)
        case .BTC:
            self.tickerBTCList = tickerList
            self.tabBTCList = self.sortList(orderBy: sortInfo.orderby,
                                            standard: sortInfo.standard,
                                            list: currencyNameList)
        }
        completion()
    }
}
