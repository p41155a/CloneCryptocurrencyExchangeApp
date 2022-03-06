//
//  ConcludedQuantityTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import UIKit

class ConcludedQuantityTableViewCell: UITableViewCell {
    @IBOutlet weak var concludedPriceLabel: UILabel!
    @IBOutlet weak var concludedQuantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
//        self.concludedPriceLabel.text = nil
//        self.concludedQuantityLabel.text = nil
    }
}
