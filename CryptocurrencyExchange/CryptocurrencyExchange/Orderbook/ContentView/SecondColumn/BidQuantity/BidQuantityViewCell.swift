//
//  BuyQuantityViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class BidQuantityViewCell: Cell {
    @IBOutlet private var bidQuantityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(data: OrderbookEntity) {
        self.bidQuantityLabel.text = data.quantity
    }
}
