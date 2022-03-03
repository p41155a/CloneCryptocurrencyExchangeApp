//
//  CrypocurrencyListTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

class CrypocurrencyListTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var chageRateLabel: UILabel!
    @IBOutlet weak var chageAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     
    func setData(data: CrypotocurrencyListTableViewEntity) {
        self.currencyNameLabel.text = data.symbol
        self.currentPriceLabel.text = data.currentPrice
    }
    
}
