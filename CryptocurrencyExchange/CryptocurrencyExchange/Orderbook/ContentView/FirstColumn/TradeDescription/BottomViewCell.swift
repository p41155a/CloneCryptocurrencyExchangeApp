//
//  BottomViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/05.
//

import UIKit
import SpreadsheetView

final class BottomViewCell: Cell {
    @IBOutlet private var prevClosePriceLabel: UILabel!
    @IBOutlet private var openPriceLabel: UILabel!
    @IBOutlet private var highPriceLabel: UILabel!
    @IBOutlet private var lowPriceLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(data: CrypotocurrencyKRWListTableViewEntity) {
        self.prevClosePriceLabel.text = data.symbol
        self.openPriceLabel.text = data.symbol
        self.highPriceLabel.text = data.symbol
        self.lowPriceLabel.text = data.symbol
    }
}

