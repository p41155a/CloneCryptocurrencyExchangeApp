//
//  CrypocurrencyListTableViewCellProtocol.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/09.
//

import UIKit

protocol CrypocurrencyListTableViewCell: UITableViewCell {
    func animateBackgroundColor()
    func setColor(updown: UpDown)
}
