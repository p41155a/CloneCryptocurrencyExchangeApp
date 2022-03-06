//
//  ConclusionTableView.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import UIKit
import SpreadsheetView

class ConclusionTableView: Cell {
    @IBOutlet weak var conclusionTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        self.conclusionTableView.delegate = self
        self.conclusionTableView.dataSource = self
        self.conclusionTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        FasteningStrengthTableViewCell.register(tableView: conclusionTableView)
        ConcludedQuantityTableViewCell.register(tableView: conclusionTableView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ConclusionTableView: UITableViewDelegate {
}

extension ConclusionTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 29
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let fasteningStrengthTableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: FasteningStrengthTableViewCell.self), for: indexPath) as! FasteningStrengthTableViewCell
            
            fasteningStrengthTableCell.fasteningStrengthLabel.text! = "111.14%"
            
            return fasteningStrengthTableCell
        } else {
            let concludedQuantityTableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConcludedQuantityTableViewCell.self), for: indexPath) as! ConcludedQuantityTableViewCell
            
            concludedQuantityTableCell.concludedPriceLabel.text! = "48.200,000"
            concludedQuantityTableCell.concludedQuantityLabel.text! = "0.1314"
            
            return concludedQuantityTableCell
        }
    }
}
