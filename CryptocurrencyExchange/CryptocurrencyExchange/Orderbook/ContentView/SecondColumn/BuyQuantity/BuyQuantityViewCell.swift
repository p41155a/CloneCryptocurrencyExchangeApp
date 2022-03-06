//
//  BuyQuantityViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class BuyQuantityViewCell: Cell {
    @IBOutlet weak var buyQuantityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override func prepareForReuse() {
//        self.buyQuantityLabel.text = nil
//    }
}
