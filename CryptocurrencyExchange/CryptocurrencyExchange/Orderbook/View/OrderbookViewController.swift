
import UIKit
import Starscream
import SpreadsheetView

final class OrderbookViewController: ViewControllerInjectingViewModel<OrderbookViewModel> {
    private let urlStr: String = "wss://pubwss.bithumb.com/pub/ws"
    private var socket: WebSocket?
    private var socketType: [String] = [
        WebSocketType.ticker.rawValue,
        WebSocketType.orderbookdepth.rawValue,
    ]
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSpreadsheetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataInit {
            self.connect()
        }
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disconnect()
    }
    
    // MARK: - Bind viewModel
    func bind() {
        self.viewModel.transactionList.bind { [weak self] _ in
            self?.spreadsheetView.reloadData()
        }
        self.viewModel.askOrderbooksList.bind { [weak self] _ in
            self?.spreadsheetView.reloadData()
        }
        self.viewModel.bidOrderbooksList.bind { [weak self] _ in
            self?.spreadsheetView.reloadData()
        }
        self.viewModel.fasteningStrengthList.bind { [weak self] _ in
            self?.spreadsheetView.reloadData()
        }
        self.viewModel.closedPrice.bind { [weak self] _ in
            self?.spreadsheetView.reloadData()
        }
        self.viewModel.tradeDescriptionList.bind { [weak self] _ in
            self?.spreadsheetView.reloadData()
        }
    }
    
    private func dataInit(completionHandler: @escaping (() -> Void)) {
        self.viewModel.setOrderbookAPIData()
        self.viewModel.setTickerAPIData()
        self.viewModel.setTransactionAPIData()
    }
    
    private func configureSpreadsheetView() {
        self.spreadsheetView.delegate = self
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.backgroundColor = .black
        
        registerCell()
        focusToCenter(of: self.spreadsheetView)
    }
    
    /// SpreadsheetView를 위한 Cell 등록을 합니다.
    private func registerCell() {
        AskQuantityViewCell.register(spreadsheet: spreadsheetView.self)
        AskPriceViewCell.register(spreadsheet: spreadsheetView.self)
        
        EmptyViewCell.register(spreadsheet: spreadsheetView.self)
        TopViewCell.register(spreadsheet: spreadsheetView.self)
        BottomViewCell.register(spreadsheet: spreadsheetView.self)
        
        ConclusionTableView.register(spreadsheet: spreadsheetView.self)
        
        BidQuantityViewCell.register(spreadsheet: spreadsheetView.self)
        BidPriceViewCell.register(spreadsheet: spreadsheetView.self)
    }
    
    /// View가 Center에서 시작을 할 수 있도록 설정합니다.
    private func focusToCenter(of contentView: SpreadsheetView) {
        self.view.layoutIfNeeded()
        let centerOffsetX = (contentView.contentSize.width) / 3
        let centerOffsetY = (contentView.contentSize.height) / 3
        let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
        contentView.setContentOffset(centerPoint, animated: false)
    }
}

extension OrderbookViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let _):
            self.writeToSocket(
                for: viewModel.orderCurrency.value,
                of: viewModel.paymentCurrency
            )
        case .disconnected(let reason, let code):
            break
        case .text(let data):
            self.viewModel.set(from: data)
            break
        default:
            break
        }
    }
    
    // MARK: - func<websocket>
    private func connect() {
        guard let url = URL(string: urlStr),
              var request = URLRequest(url: url) as? URLRequest else {
                  return
              }
        
        request.timeoutInterval = 1
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    private func disconnect() {
        socket?.disconnect()
        socket?.delegate = nil
    }
    
    private func writeToSocket(for coinName: String, of paymentCurrency: PaymentCurrency) {
        self.socketType.map { [weak self] in
            let params: [String: Any] = ["type": $0,
                                         "symbols": ["\(coinName)_\(paymentCurrency.value)"],
                                         "tickTypes": [WebSocketTickType.tickMID.rawValue]
            ]
            let json = try! JSONSerialization.data(withJSONObject: params, options: [])
            self?.socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
        }
    }
}
