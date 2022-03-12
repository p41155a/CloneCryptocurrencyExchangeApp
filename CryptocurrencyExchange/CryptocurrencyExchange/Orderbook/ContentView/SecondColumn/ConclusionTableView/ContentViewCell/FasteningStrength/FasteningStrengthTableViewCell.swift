//
//  FasteningStrengthTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import UIKit

final class FasteningStrengthTableViewCell: UITableViewCell {
    @IBOutlet private var fasteningStrengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.fasteningStrengthLabel.text = nil
    }
    
    func setData(data: Double) {
        self.fasteningStrengthLabel.text = "\(data)%"
        var color:UpDown = data > 100.0 ? .up : .down
        if data == 100 {
            color = .zero
        }
        setColor(updown: UpDown(rawValue: color.rawValue) ?? .zero)
    }
    
    private func setColor(updown: UpDown) {
        self.fasteningStrengthLabel.textColor = updown.color
    }
}
