//
//  TransactionInformationCell.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import UIKit

class TransactionInformationCell: UICollectionViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUI(with information: TransactionInforamtion, column: ColumnOfTransactionList) {
        self.infoLabel.textColor = information.saleType == .salesAsk ? .decreasingColor : .increasingColor
        self.infoLabel.text = column == .price ? information.price : information.amount
    }
}
