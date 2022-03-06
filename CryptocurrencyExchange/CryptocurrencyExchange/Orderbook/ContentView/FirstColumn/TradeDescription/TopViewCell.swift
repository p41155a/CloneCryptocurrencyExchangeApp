//
//  TopViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/05.
//

import UIKit
import SpreadsheetView

final class TopViewCell: Cell {
    @IBOutlet weak var tradeVolumeLabel: UILabel!
    @IBOutlet weak var tradeValueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
