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

extension OrderbookViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension OrderbookViewController: SpreadsheetViewDataSource {
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return UIScreen.main.bounds.width / 3
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 30
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        3
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        60
    }
    
    // 각 컬럼의 row들을 합치는 곳입니다.
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return [
            CellRange(from: (row: 0, column: 2), to: (row: 25, column: 2)),
            CellRange(from: (row: 27, column: 2), to: (row: 29, column: 2)),
            CellRange(from: (row: 30, column: 0), to: (row: 59, column: 0))
        ]
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch indexPath.column {
        case 0:
            if indexPath.row < 30 {
                let sellQuantityCell = SellQuantityViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
                sellQuantityCell.sellQuantityLabel.text! = "0.2405"
                
                return sellQuantityCell
            } else if indexPath.row == 30 {
                let conclusionTableViewCell = ConclusionTableView.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
                return conclusionTableViewCell
            }
            
        case 1:
            if indexPath.row < 30 {
                let sellPriceViewCell = SellPriceViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
                sellPriceViewCell.sellPriceLabel.text! = "48,155,500"
                sellPriceViewCell.sellPriceRateLabel.text! = "-4.65%"
                
                return sellPriceViewCell
            } else {
                let buyPriceViewCell = BuyPriceViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
                buyPriceViewCell.buyPriceLabel.text! = "48,100,000"
                buyPriceViewCell.buyPriceRateLabel.text! = "-4.71%"
                
                return buyPriceViewCell
            }
        case 2:
            if indexPath.row >= 30 {
                let buyQuantityViewCell = BuyQuantityViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
                buyQuantityViewCell.buyQuantityLabel.text! = "0.0042"
                
                
                return buyQuantityViewCell
            } else if indexPath.row == 26 {
                let descriptionTopCell = TopViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
                descriptionTopCell.tradeVolumeLabel.text! = "3,360,062 BTC"
                descriptionTopCell.tradeValueLabel.text! = "1,676,600 억"
                
                return descriptionTopCell
            } else if indexPath.row == 27 {
                let descriptionBottomCell = BottomViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
                descriptionBottomCell.prevClosePriceLabel.text! = "50,550,000"
                descriptionBottomCell.openPriceLabel.text! = "50,560,000"
                descriptionBottomCell.highPriceLabel.text! = "50,691,000\n0.28%"
                descriptionBottomCell.lowPriceLabel.text! = "47,900,000\n-5.24%"
                
                return descriptionBottomCell
            }
        default:
            break
        }
        return nil
    }
}

extension Cell {
    static func register(spreadsheet: SpreadsheetView) {
        let Nib = UINib(nibName: self.NibName, bundle: nil)
        spreadsheet.register(Nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableCell(spreadsheet: SpreadsheetView, indexPath: IndexPath) -> Self {
        guard let cell = spreadsheet.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Error! \(self.reuseIdentifier)")
        }
        
        return cell as! Self
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var NibName: String {
        return String(describing: self)
    }
}
