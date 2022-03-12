//
//  AssetsStatusTableViewCell.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/12.
//

import UIKit

final class AssetsStatusTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureUI()
    }
    
    private func configureUI() {
        possibleWithdrawalView.layer.cornerRadius = possibleWithdrawalView.frame.width / 2
        possibleDepositView.layer.cornerRadius = possibleWithdrawalView.frame.width / 2
    }
    
    func setData(by order: String, status: EachAccountStatus) {
        titleLabel.text = order
        possibleWithdrawalView.backgroundColor = getColor(by: status.withdrawalStatus)
        possibleDepositView.backgroundColor = getColor(by: status.depositStatus)
        possibleDepositLabel.text = getStatus(by: status.withdrawalStatus)
        possibleWithdrawalLabel.text = getStatus(by: status.depositStatus)
    }
    
    private func getColor(by status: Int) -> UIColor {
        return status == 1 ? .blue : .red
    }
    
    private func getStatus(by status: Int) -> String {
        return status == 1 ? "정상" : "중단"
    }
    
    @IBOutlet weak var possibleWithdrawalLabel: UILabel!
    @IBOutlet weak var possibleDepositLabel: UILabel!
    @IBOutlet weak var possibleWithdrawalView: UIView!
    @IBOutlet weak var possibleDepositView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
}
