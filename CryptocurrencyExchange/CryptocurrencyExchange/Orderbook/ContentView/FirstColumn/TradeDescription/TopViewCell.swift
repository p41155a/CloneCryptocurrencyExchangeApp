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
    
    override func prepareForReuse() {
        self.tradeVolumeLabel.text = nil
        self.tradeValueLabel.text = nil
    }
    
    func setData(data: TradeDescriptionEntity) {
        let splitedSymbol: [String] = data
            .symbol
            .split(separator: "_")
            .map {
            "\($0)"
        }
        let result = ceil(data.volume.doubleValue ?? 0.0)
        
        self.tradeVolumeLabel.text = "\(result)\(splitedSymbol[0])"
        self.tradeValueLabel.text = data.value
    }
}
