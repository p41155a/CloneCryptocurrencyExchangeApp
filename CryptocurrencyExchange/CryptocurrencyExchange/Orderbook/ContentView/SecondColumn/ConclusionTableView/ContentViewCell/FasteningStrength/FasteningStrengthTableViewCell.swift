//
//  FasteningStrengthTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import UIKit

class FasteningStrengthTableViewCell: UITableViewCell {
    @IBOutlet weak var fasteningStrengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.fasteningStrengthLabel.text = nil
    }
}
