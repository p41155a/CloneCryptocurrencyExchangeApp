//
//  BuyPriceViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class BuyPriceViewCell: Cell {
    @IBOutlet weak var buyPriceLabel: UILabel!
    @IBOutlet weak var buyPriceRateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
//    override func prepareForReuse() {
//        self.buyPriceLabel.text = nil
//        self.buyPriceRateLabel.text = nil
//    }
}
