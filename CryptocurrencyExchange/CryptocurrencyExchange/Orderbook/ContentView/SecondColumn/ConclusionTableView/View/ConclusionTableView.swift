//
//  ConclusionTableView.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import UIKit
import SpreadsheetView
import Starscream

final class ConclusionTableView: Cell {
    @IBOutlet weak var conclusionTableView: UITableView!
    
    var fasteningStrengthData: String = ""
    var concludedQuantityList: [TransactionEntity] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        self.conclusionTableView.delegate = self
        self.conclusionTableView.dataSource = self
        self.conclusionTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.conclusionTableView.backgroundColor = .tabBarColor

        FasteningStrengthTableViewCell.register(tableView: conclusionTableView)
        ConcludedQuantityTableViewCell.register(tableView: conclusionTableView)
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
        return 31
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let fasteningStrengthTableCell = FasteningStrengthTableViewCell.dequeueReusableCell(tableView: tableView)
            
            fasteningStrengthTableCell.setData(data: fasteningStrengthData.doubleValue ?? 0.0)
            
            return fasteningStrengthTableCell
        } else {
            let concludedQuantityTableCell = ConcludedQuantityTableViewCell.dequeueReusableCell(tableView: tableView)

            if concludedQuantityList.count > indexPath.row {
                concludedQuantityTableCell.setData(data: concludedQuantityList[indexPath.row - 1])
            }
            
            return concludedQuantityTableCell
        }
    }
}
