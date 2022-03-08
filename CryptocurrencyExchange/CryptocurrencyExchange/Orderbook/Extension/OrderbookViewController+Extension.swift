//
//  OrderbookViewController.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import Foundation
import SpreadsheetView

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
                
//                sellQuantityCell.setData(data: <#T##CrypotocurrencyKRWListTableViewEntity#>)
                
                return sellQuantityCell
            } else if indexPath.row == 30 {
                let conclusionTableViewCell = ConclusionTableView.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
//                conclusionTableViewCell.coinName = coinName
//                conclusionTableViewCell.currrencyType = currrencyType
//                
                return conclusionTableViewCell
            }
            
        case 1:
            if indexPath.row < 30 {
                let sellPriceViewCell = SellPriceViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
//                sellPriceViewCell.setData(data: <#T##CrypotocurrencyKRWListTableViewEntity#>)
                
                return sellPriceViewCell
            } else {
                let buyPriceViewCell = BuyPriceViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
//                buyPriceViewCell.setData(data: <#T##CrypotocurrencyKRWListTableViewEntity#>)
                
                return buyPriceViewCell
            }
        case 2:
            if indexPath.row >= 30 {
                let buyQuantityViewCell = BuyQuantityViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
//                buyQuantityViewCell.setData(data: <#T##CrypotocurrencyKRWListTableViewEntity#>)
                
                return buyQuantityViewCell
            } else if indexPath.row == 26 {
                let descriptionTopCell = TopViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
//                descriptionTopCell.setData(data: <#T##CrypotocurrencyKRWListTableViewEntity#>)
                
                return descriptionTopCell
            } else if indexPath.row == 27 {
                let descriptionBottomCell = BottomViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath)
                
//                descriptionBottomCell.setData(data: <#T##CrypotocurrencyKRWListTableViewEntity#>)

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
