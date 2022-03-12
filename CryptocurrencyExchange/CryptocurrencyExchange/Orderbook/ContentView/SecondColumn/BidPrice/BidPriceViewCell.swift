//
//  BuyPriceViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import UIKit
import SpreadsheetView

final class BidPriceViewCell: Cell {
    @IBOutlet private var bidPriceLabel: UILabel!
    @IBOutlet private var bidPriceRateLabel: UILabel!
    
    private let viewModel = ContentViewModel.shared
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        self.bidPriceLabel.text = nil
        self.bidPriceRateLabel.text = nil
    }
    
    func setData(data: OrderbookEntity, closedPrice: String) {
        let calculated = (data.price.doubleValue ?? 0.0) - (closedPrice.doubleValue ?? 0.0)
        let sign = calculated > 0 ? "+" : "-"
        setColor(plusMinus: PlusMinus(rawValue: String(sign).first ?? "0") ?? .zero)

        self.bidPriceLabel.text = data.commaPrice
        self.bidPriceRateLabel.text = sign + viewModel.calculatePercentage(
            closePrice: closedPrice,
            price: data.price,
            calculatedPrice: calculated
        ) + "%"
    }
    
    private func setColor(plusMinus: PlusMinus) {
        self.bidPriceLabel.textColor = plusMinus.color
        self.bidPriceRateLabel.textColor = plusMinus.color
    }
}
