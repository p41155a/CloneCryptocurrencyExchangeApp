//
//  SpreadsheetView.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/05.
//

import Foundation
import SpreadsheetView

extension Cell {
    static func register(spreadsheet: SpreadsheetView) {
        let Nib = UINib(nibName: self.NibName, bundle: nil)
        spreadsheet.register(Nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var NibName: String {
        return String(describing: self)
    }
}

extension OrderbookViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
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
    
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return [
            CellRange(from: (row: 0, column: 2), to: (row: 29, column: 2)),
            CellRange(from: (row: 30, column: 0), to: (row: 59, column: 0))
        ]
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.column == 0 && indexPath.row < 30 {
            let sellQuantityCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: SellQuantityViewCell.self), for: indexPath) as? SellQuantityViewCell
            
            sellQuantityCell?.sellQuantityLabel.text! = "0.2405"
            sellQuantityCell?.contentView.backgroundColor = .decreasingColor
            
            return sellQuantityCell
        } else if indexPath.column == 0 && indexPath.row == 0 {
            let fasteningStrengthCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: FasteningStrengthViewCell.self), for: indexPath) as? FasteningStrengthViewCell
            
            fasteningStrengthCell?.fasteningStrengthLabel.text! = "111.14%"
            fasteningStrengthCell?.contentView.backgroundColor = .clear
            
            return fasteningStrengthCell
        } else {
            let concludedQuantityViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ConcludedQuantityViewCell.self), for: indexPath) as? ConcludedQuantityViewCell
            
            concludedQuantityViewCell?.concludedPriceLabel.text! = "48.200,000"
            concludedQuantityViewCell?.concludedQuantityLabel.text! = "0.1314"
            concludedQuantityViewCell?.contentView.backgroundColor = .clear
            
            return concludedQuantityViewCell
        }
        
        if indexPath.column == 1 && indexPath.row < 30 {
            let sellPriceViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: SellPriceViewCell.self), for: indexPath) as? SellPriceViewCell
            
            sellPriceViewCell?.sellPriceLabel.text! = "48,155,500"
            sellPriceViewCell?.sellPriceRateLabel.text! = "-4.65%"
            sellPriceViewCell?.contentView.backgroundColor = .decreasingColor
            
            return sellPriceViewCell
        } else {
            let buyPriceViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BuyPriceViewCell.self), for: indexPath) as? BuyPriceViewCell
            
            buyPriceViewCell?.buyPriceLabel.text! = "48,100,000"
            buyPriceViewCell?.buyPriceRateLabel.text! = "-4.71%"
            buyPriceViewCell?.contentView.backgroundColor = .increasingColor
            
            return buyPriceViewCell
        }
        
        if indexPath.column == 2 && indexPath.row >= 30 {
            let buyQuantityViewCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BuyQuantityViewCell.self), for: indexPath) as? BuyQuantityViewCell
            
            buyQuantityViewCell?.buyQuantityLabel.text! = "0.0042"
            buyQuantityViewCell?.contentView.backgroundColor = .increasingColor
            
            return buyQuantityViewCell
        } else if indexPath.row == 0 {
            let descriptionBottomCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BottomViewCell.self), for: indexPath) as? BottomViewCell
            
            descriptionBottomCell?.prevClosePriceLabel.text! = "50,550,000"
            descriptionBottomCell?.openPriceLabel.text! = "50,560,000"
            descriptionBottomCell?.highPriceLabel.text! = "50,691,000\n0.28%"
            descriptionBottomCell?.lowPriceLabel.text! = "47,900,000\n-5.24%"
            descriptionBottomCell?.contentView.backgroundColor = .clear
            
            return descriptionBottomCell
        } else if indexPath.row == 1 {
            let descriptionTopCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TopViewCell.self), for: indexPath) as? TopViewCell
            
            descriptionTopCell?.tradeVolumeLabel.text! = "3,360,062 BTC"
            descriptionTopCell?.tradeValueLabel.text! = "1,676,600 억"
            
            descriptionTopCell?.contentView.backgroundColor = .clear
            
            return descriptionTopCell
        } else if indexPath.row == 2 {
        }
    }
}
