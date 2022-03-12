//
//  BottomViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/05.
//

import UIKit
import SpreadsheetView

final class BottomViewCell: Cell {
    @IBOutlet private var prevClosePriceLabel: UILabel!
    @IBOutlet private var openPriceLabel: UILabel!
    @IBOutlet private var highPriceLabel: UILabel!
    @IBOutlet private var lowPriceLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        self.prevClosePriceLabel.text = nil
        self.openPriceLabel.text = nil
        self.highPriceLabel.text = nil
        self.lowPriceLabel.text = nil
    }
    
    func setData(data: TradeDescriptionEntity) {
        self.prevClosePriceLabel.text = Int(data.prevClosingPrice)?.decimalType ?? ""
        self.openPriceLabel.text = Int(data.openingPrice)?.decimalType ?? ""
        self.highPriceLabel.text =
        "\(Int(data.maxPrice)?.decimalType ?? "")\n\(calculatePercentage(preClosePrice: data.prevClosingPrice, price: data.maxPrice))%"
        self.lowPriceLabel.text =
        "\(Int(data.minPrice)?.decimalType ?? "")\n-\(calculatePercentage(preClosePrice: data.prevClosingPrice, price: data.minPrice))%"
    }
    
    private func calculatePercentage(
        preClosePrice: String,
        price: String
    ) -> Double {
        guard let preClosePrice = Double(preClosePrice) as? Double,
              let price = Double(price) as? Double else {
                  return 0.0
              }
        let digit: Double = pow(10, 3)
        let absPrice = abs(preClosePrice - price)
        let result = (absPrice)/preClosePrice * 100
        
        return round(result * digit)/digit
    }
}
