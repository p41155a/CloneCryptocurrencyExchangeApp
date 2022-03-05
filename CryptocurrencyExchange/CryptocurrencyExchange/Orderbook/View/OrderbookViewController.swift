//
//  OrderBookViewController.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import Starscream
import SpreadsheetView

final class OrderbookViewController: ViewControllerInjectingViewModel<OrderbookViewModel> {
    var coinName: String = ""
    var currrencyType: String = ""
    
    var spreadsheetView = SpreadsheetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view.frame
        spreadsheetView = SpreadsheetView(
            frame: CGRect(
                origin: CGPoint(x: 0, y: 100),
                size: CGSize(width: UIScreen.main.bounds.width, height: view.height - 250)
            )
        )
        self.view.addSubview(spreadsheetView)
        
        configureSpreadsheetView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.spreadsheetView.flashScrollIndicators()
    }
    
    private func configureSpreadsheetView() {
        self.spreadsheetView.delegate = self
        self.spreadsheetView.dataSource = self
        registerCell()
    }
    
    private func registerCell() {
        SellQuantityViewCell.register(spreadsheet: spreadsheetView.self)
        SellPriceViewCell.register(spreadsheet: spreadsheetView.self)
        
        TopViewCell.register(spreadsheet: spreadsheetView.self)
        BottomViewCell.register(spreadsheet: spreadsheetView.self)
        
        FasteningStrengthViewCell.register(spreadsheet: spreadsheetView.self)
        BuyQuantityViewCell.register(spreadsheet: spreadsheetView.self)
        BuyPriceViewCell.register(spreadsheet: spreadsheetView.self)
    }
}

extension OrderbookViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            let params: [String: Any] = ["type": WebSocketType.orderbookdepth.rawValue,
                                         "symbols": "\(coinName)_\(currrencyType)"
            ]
            
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
