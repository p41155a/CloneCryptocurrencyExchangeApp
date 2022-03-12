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
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        self.askPriceLabel.text = nil
        self.askPriceRateLabel.text = nil
    }
    
    func setData(data: OrderbookEntity, closedPrice: String) {
        self.askPriceLabel.text = data.commaPrice
        self.askPriceRateLabel.text = calculatePercentage(
            closePrice: closedPrice,
            price: data.price) + "%"
    }
    
    private func calculatePercentage(
        closePrice: String,
        price: String
    ) -> String {
        guard let closePrice = Double(closePrice) as? Double,
              let price = Double(price) as? Double else {
                  return ""
              }
        let digit: Double = pow(10, 2)
        let absPrice = abs(closePrice - price)
        let result = (absPrice)/closePrice * 100
        
        return "\(round(result * digit)/digit)"
    }
}
