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
    var currencyNameList: [String] = []
    var dataForTableView: Observable<[String: CrypotocurrencyListTableViewEntity]> = Observable([:])
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        cells.forEach { cell in
            cell.register(tableView: tableView)
        }
        bind()
    }
    
    func bind() {
        self.dataForTableView.bind { [weak self] data in
            self?.tableView.reloadData()
        }
    }
}
extension CryptocurrencyListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentName = currencyNameList[indexPath.row]
        guard let data = dataForTableView.value[currentName] else {
            return UITableViewCell()
        }
        let cell = CrypocurrencyListTableViewCell.dequeueReusableCell(tableView: tableView)
        cell.setData(data: data)
        return cell
    }
}
