//
//  ConcludedQuantityTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import UIKit

final class ConcludedQuantityTableViewCell: UITableViewCell {
    @IBOutlet private var concludedPriceLabel: UILabel!
    @IBOutlet private var concludedQuantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.concludedPriceLabel.text = nil
        self.concludedQuantityLabel.text = nil
    }
    
    func setData(data: TransactionEntity) {
        self.concludedPriceLabel.text = data.commaPrice
        self.concludedQuantityLabel.text = data.quantity
        
        setColor(of: data.type)
    }
    
    func setColor(of state: WebSocketEachTransaction.BuySellGb) {
        concludedPriceLabel.textColor = state.color
        concludedQuantityLabel.textColor = state.color
    }
}
