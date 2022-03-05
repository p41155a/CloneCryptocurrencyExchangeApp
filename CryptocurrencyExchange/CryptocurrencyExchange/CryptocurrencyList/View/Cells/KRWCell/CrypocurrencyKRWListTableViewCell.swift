//
//  CrypocurrencyListTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

final class CrypocurrencyKRWListTableViewCell: UITableViewCell {
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
        self.changeAmountLabel.text = nil
        self.transactionAmountLabel.text = nil
    }
    
    func setData(data: CrypotocurrencyKRWListTableViewEntity) {
        self.currencyNameLabel.text = data.symbol
        self.currencyNameSubNameLabel.text = data.payment.value
        self.currentPriceLabel.text = data.currentPrice
        self.changeRateLabel.text = data.changeRate
        self.changeAmountLabel.text = data.changeAmount
        self.transactionAmountLabel.text = data.transactionAmount
        setColor(updown: UpDown(rawValue: data.changeAmount.first ?? "0") ?? .zero)
    }
    
    private func setColor(updown: UpDown) {
        currentPriceLabel.textColor = updown.color
        changeRateLabel.textColor = updown.color
        changeAmountLabel.textColor = updown.color
    }
    
    // MARK: - Property
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyNameSubNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changeAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
}

enum UpDown: Character {
    case up = "+"
    case down = "-"
    case zero = "0"
    
    var color: UIColor {
        switch self {
        case .up:
            return .increasingColor ?? .red
        case .down:
            return .decreasingColor ?? .blue
        case .zero:
            return .titleColor ?? .black
        }
    }
}
