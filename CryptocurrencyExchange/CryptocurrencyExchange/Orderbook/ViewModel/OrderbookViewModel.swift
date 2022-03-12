
import Foundation

protocol DataSetable {
    func checkWebSocketType(for data: String)
}

class OrderbookViewModel: XIBInformation {
    var nibName: String?
    var orderCurrency: OrderCurrency
    var paymentCurrency: PaymentCurrency
    
    
    let orderbookAPI = OrderbookAPIManager()
    let tickerAPI = TickerAPIManager()
    let transactionAPI = TransactionAPIManager()
    
    let orderbookManager = OrderbookManager()
    var askOrderbooksList: Observable<[OrderbookEntity]> = Observable([]) {
        didSet {
            self.orderbookManager.delegate?.coinOrderbookDataManager(
                didChange: askOrderbooksList.value,
                and: bidOrderbooksList.value
            )
            self.orderbookManager.calculateTotalOrderQuantity(
                orderbooks: askOrderbooksList.value,
                type: .ask
            )
        }
    }
    var bidOrderbooksList: Observable<[OrderbookEntity]> = Observable([]) {
        didSet {
            self.orderbookManager.delegate?.coinOrderbookDataManager(
                didChange: askOrderbooksList.value,
                and: bidOrderbooksList.value
            )
            self.orderbookManager.calculateTotalOrderQuantity(
                orderbooks: bidOrderbooksList.value,
                type: .bid
            )
        }
    }
    var closedPrice: Observable<String> = Observable("")
    
    var tradeDescriptionList: Observable<[TradeDescriptionEntity]> = Observable([])
    var fasteningStrengthList: Observable<String> = Observable("")
    var transactionList: Observable<[TransactionEntity]> = Observable([])
    
    init(
        nibName: String? = nil,
        orderCurrency: OrderCurrency,
        paymentCurrency: PaymentCurrency
    ) {
        self.nibName = nibName
        self.orderCurrency = orderCurrency
        self.paymentCurrency = paymentCurrency
    }
    
    func set(from data: String) {
        self.checkWebSocketType(for: data)
    }
}

extension OrderbookViewModel {
    //MARK: Orderbook
    func setOrderbookAPIData() {
        orderbookAPI.fetchOrderbook(
            orderCurrency: orderCurrency,
            paymentCurrency: paymentCurrency) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.setOrderbooks(from: data)
                case .failure(_):
                    break
                }
            }
    }
    
    private func setOrderbooks(from orderbook: OrderBook) {
        askOrderbooksList.value = orderbook.data.asks.map {
            $0.generate(type: .ask)
        }.reversed()
        
        bidOrderbooksList.value = orderbook.data.bids.map {
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
                print("data : \(data)")
                self?.setTickers(from: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func setTickers(from ticker: TickerEntity) {
        let tickerInfo = ticker.currentInfo.current.map {
            $0.value.generate()
        }
        tradeDescriptionList.value = tickerInfo
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
                print("transactionAPI Data : \(data)")
            case .failure(let error):
                print("transactionAPI error : \(error)")
                break
            }
        }
    }
    
    private func setTransactions(from transaction: TransactionValue) {
        let transactionInfo = transaction.data.map {
            $0.generate()
        }.reversed()
        
        transactionList.value.insert(contentsOf: transactionInfo, at: Int.zero)
    }
}

extension OrderbookViewModel {
    fileprivate func checkWebSocketType(for data: String) {
        guard let data = data.data(using: .utf8) as? Data,
              let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                  return
              }
        
        if let webSocketType = json["type"] as? String{
            self.approach(to: data, of: WebSocketType(rawValue: webSocketType)?.rawValue ?? "")
        }
    }
    
    /// WebSocket Type별로 접근.
    private func approach(to data: Data, of type: String) {
        switch type {
        case "ticker" :
            guard let json = Decoded<WebSocketTickerEntity>(data: data),
                  let value = json.value else {
                      return
                  }
            
            setWebSocketTickerData(with: value)
        case "orderbookdepth":
            guard let json = Decoded<WebSocketOrderbookEntity>(data: data),
                  let value = json.value else {
                      return
                  }
            
            setWebSocketOrderbookData(with: value)
        case "transaction":
            guard let json = Decoded<WebSocketTransactionEntity>(data: data),
                  let value = json.value else {
                      return
                  }
            
            setWebSocketTransactionData(with: value)
        default:
            break
        }
    }
}

extension OrderbookViewModel {
    private func setWebSocketOrderbookData(
        with entity: WebSocketOrderbookEntity,
        at index: Int = Int.zero
    ) {
        let webSocketAskOrderbooks = entity.content.asks.map {
            $0.generate()
        }
        
        orderbookManager.updateOrderbook(
            orderbooks: webSocketAskOrderbooks,
            to: &askOrderbooksList.value,
            type: .ask)
        
        let webSocketBidOrderbooks = entity.content.bids.map {
            $0.generate()
        }
        
        orderbookManager.updateOrderbook(
            orderbooks: webSocketBidOrderbooks,
            to: &bidOrderbooksList.value,
            type: .bid
        )
    }
}

extension OrderbookViewModel {
    private func setWebSocketTransactionData(
        with entity: WebSocketTransactionEntity,
        at index: Int = Int.zero
    ) {
        let transactionInfo = entity.content.list.map {
            $0.generate()
        }.reversed()
        
        transactionList.value.insert(contentsOf: transactionInfo, at: index)
    }
}

extension OrderbookViewModel {
    private func setWebSocketTickerData(with entity: WebSocketTickerEntity) {
        let tickerInfo = entity.content
        
        fasteningStrengthList.value = tickerInfo.volumePower
        closedPrice.value = tickerInfo.closePrice
        
        tradeDescriptionList.value.append(setTradeDescriptionData(
            volume: tickerInfo.volume,
            value: tickerInfo.value,
            prevClosingPrice: tickerInfo.prevClosePrice,
            openingPrice: tickerInfo.openPrice,
            maxPrice: tickerInfo.highPrice,
            minPrice: tickerInfo.lowPrice,
            symbol: tickerInfo.symbol
        ))
    }
    
    // MARK:  Trade Description
    private func setTradeDescriptionData(
        volume: String,
        value: String,
        prevClosingPrice: String,
        openingPrice: String,
        maxPrice: String,
        minPrice: String,
        symbol: String
    ) -> TradeDescriptionEntity {
        let volume: String = "\(volume)"
        let value: String = "\(Int((value.doubleValue ?? 0.0) / 1000000).decimalType ?? "")백만"
        
        let prevClosingPrice: String = "\(prevClosingPrice)".setNumStringForm()
        let openingPrice: String = "\(openingPrice)".setNumStringForm()
        let maxPrice: String = "\(maxPrice)"
        let minPrice: String = "\(minPrice)"
        let symbol: String = "\(symbol)"
        
        return TradeDescriptionEntity(
            volume: volume,
            value: value,
            prevClosingPrice: prevClosingPrice,
            openingPrice: openingPrice,
            maxPrice: maxPrice,
            minPrice: minPrice,
            symbol: symbol
        )
    }
}
