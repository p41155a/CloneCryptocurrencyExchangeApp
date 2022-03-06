//
//  SellPriceViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class SellPriceViewCell: Cell {
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var sellPriceRateLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
