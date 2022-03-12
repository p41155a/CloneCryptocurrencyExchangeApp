//
//  TransactionListViewController.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import UIKit

class TransactionListViewController: ViewControllerInjectingViewModel<TransactionListViewModel> {
    @IBOutlet weak var transactionList: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTransactionList()
        
        self.viewModel.indiceToReload.bind { [weak self] indice in
            guard let indexArr = indice else { return }
            self?.transactionList.insertItems(at: indexArr)
        }
    }
    
    private func configureTransactionList() {
        TimeInTransactionListCell.register(collectionView: transactionList)
        TransactionInformationCell.register(collectionView: transactionList)
        transactionList.dataSource = self
        transactionList.delegate = self
        
        self.priceLabel.text = "가격(\(viewModel.paymentCurrency))"
        self.amountLabel.text = "체결량(\(viewModel.orderCurrency))"

    }
    
    /// 상위 뷰컨트롤러에서 받아온 transaction socket 데이터 처리
    func transactionDataFromSocket(_ data: WebSocketTransactionContent?) {
        viewModel.updateSocketData(data)
    }
}

extension TransactionListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfInformations()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let information = viewModel.information(with: indexPath.item / viewModel.numberOfColumns)
        let columnIndex = indexPath.item % viewModel.numberOfColumns
        guard let column = ColumnOfTransactionList(rawValue: columnIndex) else { return UICollectionViewCell() }
        
        switch column {
        case .time:
            let cell = TimeInTransactionListCell.dequeueReusableCell(
                collectionView: collectionView,
                indexPath: indexPath
            )
            cell.timeLabel.text = information.date
            return cell
        case .price, .amount:
            let cell = TransactionInformationCell.dequeueReusableCell(
                collectionView: collectionView,
                indexPath: indexPath
            )
            cell.setUI(
                with: information,
                column: column
            )
            return cell
        }
    }
}

extension TransactionListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height: CGFloat = 36
        let fullWidth = UIScreen.main.bounds.width
        if indexPath.item % viewModel.numberOfColumns == 0 {
            return CGSize(width: 100, height: height)
        } else {
            return CGSize(width: (fullWidth - 100)/2, height: height)
        }
    }
}
