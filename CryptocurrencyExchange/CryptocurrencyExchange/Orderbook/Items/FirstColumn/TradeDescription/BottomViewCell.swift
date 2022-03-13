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

    private let viewModel = ContentViewModel.shared
    
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
        self.prevClosePriceLabel.text = data.prevClosingPrice.setNumStringForm()
        self.openPriceLabel.text = data.openingPrice.setNumStringForm()
        self.highPriceLabel.text =
        "\(data.maxPrice.setNumStringForm())\n\(maxRate(data: data))%"
        self.lowPriceLabel.text =
        "\(data.minPrice.setNumStringForm())\n-\(minRate(data: data))%"
    }
    
    private func maxRate(data: TradeDescriptionEntity) -> String {
        let calculatedMax = (data.prevClosingPrice.doubleValue ?? 0.0) - (data.maxPrice.doubleValue ?? 0.0)

        return viewModel.calculatePercentage(
            closePrice: data.prevClosingPrice,
            price: data.maxPrice,
            calculatedPrice: calculatedMax
        )
    }
    
    private func minRate(data: TradeDescriptionEntity) -> String {
        let calculatedMin = (data.prevClosingPrice.doubleValue ?? 0.0) - (data.minPrice.doubleValue ?? 0.0)

        return viewModel.calculatePercentage(
            closePrice: data.prevClosingPrice,
            price: data.maxPrice,
            calculatedPrice: calculatedMin
        )
    }
}
