
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
}
