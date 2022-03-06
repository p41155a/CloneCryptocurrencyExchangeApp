//
//  CrypocurrencyBTCListTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/05.
//

import UIKit

protocol CrypocurrencyListTableViewCellDelegate: AnyObject {
    func setInterestData(interest: InterestCurrency)
}
class CrypocurrencyBTCListTableViewCell: UITableViewCell {
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
        self.currentKRWPriceLabel.text = nil
        self.changeRateLabel.text = nil
        self.transactionAmountLabel.text = nil
        self.transactionKRWAmountLabel.text = nil
    }
    
    func setData(krwData: CrypotocurrencyKRWListTableViewEntity, btcData: CrypotocurrencyBTCListTableViewEntity, isInterest: Bool) {
        self.currencyNameLabel.text = btcData.symbol
        self.currencyNameSubNameLabel.text = btcData.payment.value
        self.currentPriceLabel.text = btcData.currentPrice
        self.currentKRWPriceLabel.text = krwData.currentPrice
        self.changeRateLabel.text = btcData.changeRate
        self.transactionAmountLabel.text = btcData.transactionAmount
        self.transactionKRWAmountLabel.text = krwData.transactionAmount
        self.interestButton.isSelected = isInterest
        setColor(updown: UpDown(rawValue: btcData.changeRate.first ?? "0") ?? .zero)
    }
    
    private func setColor(updown: UpDown) {
        currentPriceLabel.textColor = updown.color
        currentKRWPriceLabel.textColor = updown.color
        changeRateLabel.textColor = updown.color
    }
    
    @IBAction func interestButtonTap(_ sender: StarButton) {
        sender.isSelected.toggle()
        guard let currencyName = self.currencyNameLabel.text else {
            return
        }
        delegate?.setInterestData(
            interest: InterestCurrency(
                currency: "\(currencyName)_BTC",
                interest: interestButton.isSelected
            )
        )
    }
    
    // MARK: - Property
    weak var delegate: CrypocurrencyListTableViewCellDelegate?
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyNameSubNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var currentKRWPriceLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionKRWAmountLabel: UILabel!
    @IBOutlet weak var interestButton: StarButton!
}
