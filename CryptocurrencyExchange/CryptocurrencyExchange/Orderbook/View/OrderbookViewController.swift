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
    var coinName: String = ""
    var currrencyType: String = ""
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    var tradeDescriptionColumn: Bool = true
    var isTransactionColumn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpreadsheetView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        case .connected(let headers):
            let params: [String: Any] = ["type": WebSocketType.orderbookdepth.rawValue,
                                         "symbols": "\(coinName)_\(currrencyType)"]
            
            let jParams = try! JSONSerialization.data(withJSONObject: params, options: [])
            client.write(string: String(data:jParams, encoding: .utf8)!, completion: nil)
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            do {
                let data = string.data(using: .utf8)!
                let json = try JSONDecoder().decode(WebSocketTickerEntity.self, from: data)
                print("파싱완료한 데이터: \(json)")
            } catch  {
                print("Received text: \(string)")
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .error(let error):
            print(error?.localizedDescription ?? "")
            break
        default:
            break
        }
    }
}
