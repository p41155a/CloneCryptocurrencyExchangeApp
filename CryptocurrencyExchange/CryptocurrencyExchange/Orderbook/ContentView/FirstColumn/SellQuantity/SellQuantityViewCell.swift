//
//  SellQuantityViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class SellQuantityViewCell: Cell {
    @IBOutlet private var sellQuantityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func setData(data: CrypotocurrencyKRWListTableViewEntity) {
//        self.sellQuantityLabel.text = data.symbol
//        setColor(updown: UpDown(rawValue: data.changeAmount.first ?? "0") ?? .zero)
//    }
    
    private func setColor(updown: UpDown) {
        self.sellQuantityLabel.textColor = updown.color
    }
}
