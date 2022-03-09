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
class CrypocurrencyBTCListTableViewCell: UITableViewCell, CrypocurrencyListTableViewCell {
    // MARK: - func
    override func awakeFromNib() {
        super.awakeFromNib()
        interestButton.becomeFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
    func setData(krwData: CryptocurrencyListTableViewEntity,
                 btcData: CryptocurrencyListTableViewEntity,
                 isInterest: Bool) {
        let krwCurrentPrice: String = "\(krwData.currentPrice)".setNumStringForm(isDecimalType: true)
        let krwTransactionAmount: String = "\(Int(krwData.transactionAmount / 1000000).decimalType ?? "")백만"
        let btcCurrentPrice: String = btcData.currentPrice.displayDecimal(to: 8)
        let btcChangeRate: String = "\(btcData.changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let btcTransactionAmount: String = btcData.transactionAmount.displayDecimal(to: 3)
        
        self.currencyNameLabel.text = btcData.symbol
        self.currencyNameSubNameLabel.text = btcData.payment.value
        self.currentPriceLabel.text = btcCurrentPrice
        self.currentKRWPriceLabel.text = krwCurrentPrice
        self.changeRateLabel.text = btcChangeRate
        self.transactionAmountLabel.text = btcTransactionAmount
        self.transactionKRWAmountLabel.text = krwTransactionAmount
        self.interestButton.isSelected = isInterest
        setColor(updown: UpDown(rawValue: btcChangeRate.first ?? "0") ?? .zero)
    }
    
    func animateBackgroundColor() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            let color: UIColor? = self?.changeRateLabel.text?.first == "-" ? .decreasingColor : .increasingColor
            self?.backgroundColor = color?.withAlphaComponent(0.1)
        }) { [weak self] _ in
            self?.backgroundColor = .clear
        }
    }
    
    func setColor(updown: UpDown) {
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
