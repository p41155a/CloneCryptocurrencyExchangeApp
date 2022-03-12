//
//  SellPriceViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class AskPriceViewCell: Cell {
    @IBOutlet private var askPriceLabel: UILabel!
    @IBOutlet private var askPriceRateLabel: UILabel!
    
    private let viewModel = ContentViewModel.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(data: OrderbookEntity, closedPrice: String) {
        let calculated = (data.price.doubleValue ?? 0.0) - (closedPrice.doubleValue ?? 0.0)
        let sign = calculated > 0 ? "+" : "-"
        setColor(plusMinus: PlusMinus(rawValue: String(sign).first ?? "0") ?? .zero)

        self.askPriceLabel.text = data.commaPrice
        self.askPriceRateLabel.text = sign + viewModel.calculatePercentage(
            closePrice: closedPrice,
            price: data.price,
            calculatedPrice: calculated
        ) + "%"
    }
    
    private func setColor(plusMinus: PlusMinus) {
        self.askPriceLabel.textColor = plusMinus.color
        self.askPriceRateLabel.textColor = plusMinus.color
    }
}
