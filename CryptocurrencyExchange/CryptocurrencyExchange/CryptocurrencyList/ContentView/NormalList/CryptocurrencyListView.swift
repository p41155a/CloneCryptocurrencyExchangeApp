//
//  CryptocurrencyListView.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

final class CryptocurrencyListView: UIView {
    @IBOutlet weak var tableView: UITableView!
    let cells = [CrypocurrencyListTableViewCell.self]
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        cells.forEach { cell in
            cell.register(tableView: tableView)
        }
    }
}
extension CryptocurrencyListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CrypocurrencyListTableViewCell.dequeueReusableCell(tableView: tableView)
        
        return cell
    }
}
