//
//  SellQuantityViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class AskQuantityViewCell: Cell {
    @IBOutlet private var askQuantityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        self.askQuantityLabel.text = nil
    }
    
    func setData(data: OrderbookEntity) {
        self.askQuantityLabel.text = data.quantity
        setColor(updown: UpDown(rawValue: data.price.first ?? "0") ?? .zero)
    }
    
    private func setColor(updown: UpDown) {
        self.askQuantityLabel.textColor = updown.color
    }
}
