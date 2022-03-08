//
//  BuyPriceViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class BuyPriceViewCell: Cell {
    @IBOutlet private var buyPriceLabel: UILabel!
    @IBOutlet private var buyPriceRateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func setData(data: CrypotocurrencyKRWListTableViewEntity) {
//        self.buyPriceLabel.text = data.symbol
//        self.buyPriceRateLabel.text = data.symbol
//    }
}
