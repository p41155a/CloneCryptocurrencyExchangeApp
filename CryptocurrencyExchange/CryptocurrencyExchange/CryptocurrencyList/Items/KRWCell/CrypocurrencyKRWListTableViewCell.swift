//
//  CrypocurrencyListTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

final class CrypocurrencyKRWListTableViewCell: UITableViewCell, CrypocurrencyListTableViewCell {
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
        self.changeRateLabel.text = nil
        self.changeAmountLabel.text = nil
        self.transactionAmountLabel.text = nil
    }
    
    func setData(data: CryptocurrencyListTableViewEntity, isInterest: Bool) {
        let currentPrice: String = "\(data.currentPrice)".setNumStringForm(isDecimalType: true)
        let changeRate: String = "\(data.changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let changeAmount: String = "\(data.changeAmount)".setNumStringForm(isDecimalType: true, isMarkPlusMiuns: true)
        let transactionAmount: String = "\(Int(data.transactionAmount / 1000000).decimalType ?? "")백만"
        
        self.currencyNameLabel.text = data.order
        self.currencyNameSubNameLabel.text = data.payment.value
        self.currentPriceLabel.text = currentPrice
        self.changeRateLabel.text = changeRate
        self.changeAmountLabel.text = changeAmount
        self.transactionAmountLabel.text = transactionAmount
        self.interestButton.isSelected = isInterest
        setColor(updown: UpDown(rawValue: changeAmount.first ?? "0") ?? .zero)
    }
    
    func animateBackgroundColor() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            let color: UIColor? = self?.changeRateLabel.text?.first == "-" ? .decreasingColor : .increasingColor
            self?.backgroundColor = color?.withAlphaComponent(0.1)
        }) { [weak self] _ in
            self?.backgroundColor = .backgroundColor?.withAlphaComponent(1)
        }
    }
    
    func setColor(updown: UpDown) {
        currentPriceLabel.textColor = updown.color
        changeRateLabel.textColor = updown.color
        changeAmountLabel.textColor = updown.color
    }
    
    @IBAction func interestButtonTap(_ sender: StarButton) {
        sender.isSelected.toggle()
        guard let currencyName = self.currencyNameLabel.text else {
            return
        }
        delegate?.setInterestData(
            of: CryptocurrencySymbolInfo(
                order: currencyName,
                payment: .KRW),
            isInterest: sender.isSelected)
    }
    
    // MARK: - Property
    weak var delegate: CrypocurrencyListTableViewCellDelegate?
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyNameSubNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changeAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var interestButton: StarButton!
}
