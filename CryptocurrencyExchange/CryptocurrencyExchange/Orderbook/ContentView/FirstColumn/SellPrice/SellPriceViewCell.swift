//
//  SellPriceViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class SellPriceViewCell: Cell {
    @IBOutlet private var sellPriceLabel: UILabel!
    @IBOutlet private var sellPriceRateLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(data: CrypotocurrencyKRWListTableViewEntity) {
        self.sellPriceLabel.text = data.symbol
        self.sellPriceRateLabel.text = data.symbol
    }
}
