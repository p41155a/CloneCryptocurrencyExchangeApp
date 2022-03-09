//
//  OrderbookViewController.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/05.
//

import UIKit
import Starscream
import SpreadsheetView

final class OrderbookViewController: ViewControllerInjectingViewModel<OrderbookViewModel> {
    private var socket: WebSocket?
    private var socketType: [String] = [
        WebSocketType.ticker.rawValue,
        WebSocketType.orderbookdepth.rawValue,
        WebSocketType.transaction.rawValue
    ]
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    var tradeDescriptionColumn: Bool = true
    var isTransactionColumn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpreadsheetView()
        connect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        disconnect()
    }
    
    private func configureSpreadsheetView() {
        self.spreadsheetView.delegate = self
        self.spreadsheetView.dataSource = self
        registerCell()
        focusToCenter(of: self.spreadsheetView)
    }
    
    /// SpreadsheetView를 위한 Cell 등록을 합니다.
    private func registerCell() {
        SellQuantityViewCell.register(spreadsheet: spreadsheetView.self)
        SellPriceViewCell.register(spreadsheet: spreadsheetView.self)
        
        TopViewCell.register(spreadsheet: spreadsheetView.self)
        BottomViewCell.register(spreadsheet: spreadsheetView.self)
        
        ConclusionTableView.register(spreadsheet: spreadsheetView.self)
        
        BuyQuantityViewCell.register(spreadsheet: spreadsheetView.self)
        BuyPriceViewCell.register(spreadsheet: spreadsheetView.self)
    }
    
    /// View가 Center에서 시작을 할 수 있도록 설정합니다.
    private func focusToCenter(of contentView: SpreadsheetView) {
        self.view.layoutIfNeeded()
        let centerOffsetX = (contentView.contentSize.width - contentView.frame.size.width) / 2
        let centerOffsetY = (contentView.contentSize.height - contentView.frame.size.height) / 2
        let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
        contentView.setContentOffset(centerPoint, animated: false)
    }
}

extension OrderbookViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let _):
            self.writeToSocket(
                for: viewModel.orderCurrency,
                of: viewModel.paymentCurrency)
            
        case .disconnected(let reason, let code):
            break
        case .text(let data):
            self.viewModel.set(from: data)
        default:
            break
        }
    }
    
    // MARK: - func<websocket>
    private func connect() {
        let url = "wss://pubwss.bithumb.com/pub/ws"
        
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    private func disconnect() {
        socket?.disconnect()
        socket?.delegate = nil
    }
    
    private func writeToSocket(for coinName: String, of paymentCurrency: PaymentCurrency) {
        self.socketType.map {
            let params: [String: Any] = ["type": $0,
                                         "symbols": ["\(coinName)_\(paymentCurrency.value)"],
                                         "tickTypes": [WebSocketTickType.tickMID.rawValue]
            ]
            let json = try! JSONSerialization.data(withJSONObject: params, options: [])
            socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
        }
    }
}
