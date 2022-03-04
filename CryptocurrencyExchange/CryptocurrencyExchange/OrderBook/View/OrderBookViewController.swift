//
//  OrderBookViewController.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import Starscream
import SpreadsheetView

final class OrderBookViewController: ViewControllerInjectingViewModel<OrderBookViewModel> {
    var coinName: String = ""
    var currrencyType: String = ""
    
    @IBOutlet private var spreadsheetView: SpreadsheetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpreadsheetView()
    }
    
    private func configureSpreadsheetView() {
        self.spreadsheetView.delegate = self
        self.spreadsheetView.dataSource = self
        registerCell()
    }
    
    private func registerCell() {
        self.spreadsheetView.register(SellQuantityViewCell.self,
                                      forCellWithReuseIdentifier: String(describing: SellQuantityViewCell.self))
        self.spreadsheetView.register(SellPriceViewCell.self,
                                      forCellWithReuseIdentifier: String(describing: SellPriceViewCell.self))
        
        self.spreadsheetView.register(TopViewCell.self,
                                      forCellWithReuseIdentifier: String(describing: TopViewCell.self))
        self.spreadsheetView.register(BottomViewCell.self,
                                      forCellWithReuseIdentifier: String(describing: BottomViewCell.self))
        
        self.spreadsheetView.register(ConclusionViewCell.self,
                                      forCellWithReuseIdentifier: String(describing: ConclusionViewCell.self))
        self.spreadsheetView.register(BuyQuantityViewCell.self,
                                      forCellWithReuseIdentifier: String(describing: BuyQuantityViewCell.self))
        self.spreadsheetView.register(BuyPriceViewCell.self,
                                      forCellWithReuseIdentifier: String(describing: BuyPriceViewCell.self))
    }
}

extension OrderBookViewController: WebSocketDelegate {
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
