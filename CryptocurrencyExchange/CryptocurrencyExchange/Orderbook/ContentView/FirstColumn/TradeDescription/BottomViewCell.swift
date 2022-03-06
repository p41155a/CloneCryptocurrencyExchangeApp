//
//  BottomViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/05.
//

import UIKit
import SpreadsheetView

final class BottomViewCell: Cell {
    @IBOutlet weak var prevClosePriceLabel: UILabel!
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//    
//    override func prepareForReuse() {
//        self.prevClosePriceLabel.text = nil
//        self.openPriceLabel.text = nil
//        self.highPriceLabel.text = nil
//        self.lowPriceLabel.text = nil
//    }
}

