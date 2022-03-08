//
//  BuyQuantityViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class BuyQuantityViewCell: Cell {
    @IBOutlet private var buyQuantityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func setData(data: CrypotocurrencyKRWListTableViewEntity) {
//        self.buyQuantityLabel.text = data.symbol
//    }
}
