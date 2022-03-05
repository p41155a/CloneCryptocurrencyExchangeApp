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
        self.currencyNameLabel.text = nil
        self.currentPriceLabel.text = nil
        self.changeRateLabel.text = nil
        self.changeRateSubLabel.text = nil
        self.transactionAmountLabel.text = nil
    }
    
    func setData(data: CrypotocurrencyListTableViewEntity) {
        self.currencyNameLabel.text = data.symbol
        self.currencyNameSubNameLabel.text = data.payment.value
        self.currentPriceLabel.text = data.currentPrice
        self.changeRateLabel.text = data.changeRate
        self.changeRateSubLabel.text = data.changeAmount
        self.transactionAmountLabel.text = data.transactionAmount
        setColor(updown: UpDown(rawValue: data.changeAmount.first ?? "+") ?? .Up)
        
        switch data.payment {
        case .KRW:
            self.currentPriceSubLabel.isHidden = true
            self.transactionAmountSubLabel.isHidden = true
        case .BTC:
            self.changeRateSubLabel.isHidden = true
        }
    }
    
    private func setColor(updown: UpDown) {
        currentPriceLabel.textColor = updown.color
        changeRateLabel.textColor = updown.color
        changeRateSubLabel.textColor = updown.color
    }
    
    // MARK: - Property
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyNameSubNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var currentPriceSubLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changeRateSubLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountSubLabel: UILabel!
}

enum UpDown: Character {
    case Up = "+"
    case Down = "-"
    
    var color: UIColor {
        switch self {
        case .Up:
            return .increasingColor ?? .red
        case .Down:
            return .decreasingColor ?? .blue
        }
    }
}
