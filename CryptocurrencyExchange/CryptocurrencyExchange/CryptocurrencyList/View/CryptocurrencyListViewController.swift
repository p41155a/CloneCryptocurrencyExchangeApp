//
//  CryptocurrencyListViewController.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit
import SnapKit

final class CryptocurrencyListViewController: ViewControllerInjectingViewModel<CryptocurrencyListViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let loadedNib = Bundle.main.loadNibNamed(String(describing: CryptocurrencyListView.self), owner: self, options: nil) else { return }
        guard let cryptocurrencyListView = loadedNib.first as? CryptocurrencyListView else { return }
        contentView.addSubview(cryptocurrencyListView)
        
        cryptocurrencyListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    @IBOutlet weak var contentView: UIView!
}
