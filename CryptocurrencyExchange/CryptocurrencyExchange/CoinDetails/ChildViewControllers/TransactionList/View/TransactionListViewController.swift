//
//  TransactionListViewController.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import UIKit

class TransactionListViewController: ViewControllerInjectingViewModel<TransactionListViewModel> {
    @IBOutlet weak var transactionList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTransactionList()
        
        self.viewModel.indiceToReload.bind { [weak self] indice in
            guard let indexArr = indice else { return }
            self?.transactionList.reloadItems(at: indexArr)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TransactionListViewController connected")
//        connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        disconnect()
    }

    private func configureTransactionList() {
        TimeInTransactionListCell.register(collectionView: transactionList)
        TransactionInformationCell.register(collectionView: transactionList)
        transactionList.dataSource = self
        transactionList.delegate = self
    }
}

extension TransactionListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfInformations()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let information = viewModel.information(with: indexPath.item / 3)
        if indexPath.item % 3 == 0 {
            let cell = TimeInTransactionListCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            cell.backgroundColor = .cyan
            cell.timeLabel.text = information.date
            return cell
        }
        
        let cell = TransactionInformationCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.backgroundColor = .orange
        cell.infoLabel.text = information.amount
        return cell
    }
}

extension TransactionListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 40
        let fullWidth = UIScreen.main.bounds.width
        if indexPath.item % 3 == 0 {
            return CGSize(width: 100, height: height)
        } else {
            return CGSize(width: (fullWidth - 100)/2, height: height)
        }
    }
}
