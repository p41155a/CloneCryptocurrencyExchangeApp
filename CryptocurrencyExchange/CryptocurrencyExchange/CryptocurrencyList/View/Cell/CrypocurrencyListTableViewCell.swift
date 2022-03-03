//
//  CrypocurrencyListTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

final class CrypocurrencyListTableViewCell: UITableViewCell {
    // MARK: - func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
     
    func setData(data: CrypotocurrencyListTableViewEntity) {
        self.currencyNameLabel.text = data.symbol
        self.currentPriceLabel.text = data.currentPrice
        self.changeRateLabel.text = data.changeRate
        self.changeAmountLabel.text = data.changeAmount
        self.transactionAmountLabel.text = data.transactionAmount
    }
    
    // MARK: - Property
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changeAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
}
