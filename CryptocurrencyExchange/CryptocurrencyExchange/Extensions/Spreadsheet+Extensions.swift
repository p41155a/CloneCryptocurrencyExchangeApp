//
//  Spreadsheet+Extensions.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import Foundation
import SpreadsheetView

extension OrderBookViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}

extension OrderBookViewController: SpreadsheetViewDataSource {
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
    
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return [
            CellRange(from: (row: 0, column: 2), to: (row: 29, column: 2)),
            CellRange(from: (row: 30, column: 0), to: (row: 59, column: 0))
        ]
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.column == 0 && indexPath.row < 30 {
            let sellQuantityCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: SellQuantityViewCell.self), for: indexPath) as? SellQuantityViewCell
            
            sellQuantityCell?.contentView.backgroundColor = .decreasingColor
            
            return sellQuantityCell
        } else if indexPath.column == 0 && indexPath.row == 0 {
            let conclusionViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ConclusionViewCell.self), for: indexPath) as? ConclusionViewCell
            
            conclusionViewCell?.contentView.backgroundColor = .clear
            
            return conclusionViewCell
        } else {
            let transactionViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TransactionViewCell.self), for: indexPath) as? TransactionViewCell
            
            transactionViewCell?.contentView.backgroundColor = .clear
            
            return transactionViewCell
        }
        
        if indexPath.column ==  1 && indexPath.row < 30 {
            let sellPriceViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: SellPriceViewCell.self), for: indexPath) as? SellPriceViewCell
            
            sellPriceViewCell?.contentView.backgroundColor = .decreasingColor
            
            return sellPriceViewCell
        } else {
            let buyPriceViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BuyPriceViewCell.self), for: indexPath) as? BuyPriceViewCell
            
            buyPriceViewCell?.contentView.backgroundColor = .increasingColor
            
            return buyPriceViewCell
        }
        
        if indexPath.column == 2 && indexPath.row >= 30 {
            let buyQuantityViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BuyQuantityViewCell.self), for: indexPath) as? BuyQuantityViewCell
            
            buyQuantityViewCell?.contentView.backgroundColor = .increasingColor
            
            return buyQuantityViewCell
        } else if indexPath.row == 0 {
            let descriptionMiddleCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BottomViewCell.self), for: indexPath) as? BottomViewCell
            
            descriptionMiddleCell?.contentView.backgroundColor = .clear
            
            return descriptionMiddleCell
        } else if indexPath.row == 1 {
            let descriptionTopCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TopViewCell.self), for: indexPath) as? TopViewCell
            
            descriptionTopCell?.contentView.backgroundColor = .clear
            
            return descriptionTopCell
        } else if indexPath.row == 2 {
        }
    }
}
