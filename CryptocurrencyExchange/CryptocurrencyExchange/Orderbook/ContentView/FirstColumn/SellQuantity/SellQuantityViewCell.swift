//
//  SellQuantityViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class SellQuantityViewCell: Cell {
    @IBOutlet weak var sellQuantityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override func prepareForReuse() {
//        self.sellQuantityLabel.text = nil
//    }
}
