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
        return 50 * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item % 3 == 0 {
            let cell = TimeInTransactionListCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            cell.backgroundColor = .cyan
            return cell
        }
        
        let cell = TransactionInformationCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.backgroundColor = .orange
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
