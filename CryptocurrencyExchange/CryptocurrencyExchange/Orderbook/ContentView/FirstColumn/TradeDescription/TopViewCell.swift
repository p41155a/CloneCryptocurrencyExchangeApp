//
//  TopViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/05.
//

import UIKit
import SpreadsheetView

final class TopViewCell: Cell {
    @IBOutlet private var tradeVolumeLabel: UILabel!
    @IBOutlet private var tradeValueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func setData(data: CrypotocurrencyKRWListTableViewEntity) {
//        self.tradeVolumeLabel.text = data.symbol
//        self.tradeValueLabel.text = data.symbol
//    }
}
