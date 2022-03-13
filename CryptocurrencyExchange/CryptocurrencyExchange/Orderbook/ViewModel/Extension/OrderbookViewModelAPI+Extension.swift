//
//  OrderbookViewModelAPI+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/12.
//

import Foundation
//MARK: API
extension OrderbookViewModel {
    //MARK: Orderbook
    func setOrderbookAPIData() {
        orderbookAPI.fetchOrderbook(
            orderCurrency: orderCurrency,
            paymentCurrency: paymentCurrency
        ) { [weak self] result in
            switch result {
            case .success(let data):
                self?.setOrderbooks(from: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func setOrderbooks(from orderbook: OrderBook) {
        askOrderbooksList.value = orderbook.asks.map {
            $0.generate(type: .ask)
        }.reversed()
        
        bidOrderbooksList.value = orderbook.bids.map {
            $0.generate(type: .bid)
        }
    }
    
    //MARK: Ticker
    func setTickerAPIData() {
        tickerAPI.fetchTicker(
            orderCurrency: orderCurrency,
            paymentCurrency: paymentCurrency
        ) { [weak self] result in
            switch result {
            case .success(let data):
                self?.setTickers(from: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func setTickers(from ticker: TickerInfo) {
        let tickerInfo = ticker.generate(currencyName: orderCurrency.value)
        
        closedPrice.value = ticker.closingPrice
        print("ticker Info: \(tickerInfo) ")
        tradeDescriptionList.value.append(tickerInfo)
    }
    
    //MARK: Transaction
    func setTransactionAPIData() {
        transactionAPI.fetchTransaction(
            orderCurrency: orderCurrency,
            paymentCurrency: paymentCurrency
        ) { [weak self] result in
            switch result {
            case .success(let data):
                self?.setTransactions(from: data)
            case .failure(let error):
                break
            }
        }
    }
    
    private func setTransactions(from transaction: [TransactionData]) {
        let transactionInfo = transaction.map {
            $0.generate()
        }.reversed()
        
        transactionList.value.insert(contentsOf: transactionInfo, at: Int.zero)
    }
}
