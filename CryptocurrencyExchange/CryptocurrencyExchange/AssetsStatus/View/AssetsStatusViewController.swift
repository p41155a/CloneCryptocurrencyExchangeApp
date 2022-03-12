//
//  AssetsStatusViewController.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/08.
//

import UIKit

final class AssetsStatusViewController: ViewControllerInjectingViewModel<AssetsStatusViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        viewModel.accountList.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func configureUI() {
        AssetsStatusTableViewCell.register(tableView: tableView)
    }
    
    @IBOutlet weak var tableView: UITableView!
}

extension AssetsStatusViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accountList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AssetsStatusTableViewCell.dequeueReusableCell(tableView: tableView)
        let account = viewModel.accountList.value[indexPath.row]
        guard let status = viewModel.assetsStatus[account] else { return UITableViewCell() }
        cell.setData(by: account, status: status)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
