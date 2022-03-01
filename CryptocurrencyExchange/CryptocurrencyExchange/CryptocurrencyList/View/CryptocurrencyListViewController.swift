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
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        setContentView()
        setTabButton()
    }
    
    private func setContentView() {
        guard let cryptocurrencyListView = CryptocurrencyListView.loadFromNib() else {
            return
        }
        contentView.addSubview(cryptocurrencyListView)
        
        cryptocurrencyListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setTabButton() {
        tabButtonList = [krwTabButton, btcTabButton, interestTabButton, popularTabButton]
        tabButtonList.first?.isChoice = true
        tabButtonList.forEach { button in
            button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func buttonDidTap(_ sender: TabButton) {
        tabButtonList.forEach { button in
            button.isChoice = false
        }
        sender.isChoice = true
    }
    
    private var tabButtonList: [TabButton] = []
    @IBOutlet weak var krwTabButton: TabButton!
    @IBOutlet weak var btcTabButton: TabButton!
    @IBOutlet weak var interestTabButton: TabButton!
    @IBOutlet weak var popularTabButton: TabButton!
    @IBOutlet weak var contentView: UIView!
}
