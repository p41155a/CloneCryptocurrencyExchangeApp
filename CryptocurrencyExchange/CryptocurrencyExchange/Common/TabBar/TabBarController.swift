//
//  TabBarController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/02/26.
//

import UIKit


class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewControllers()
    }
    
    private func configureViewControllers() {
        let homeViewController = ExchangeViewController(
            viewModel: ExchangeViewModel(nibName: "ExchangeViewController")
        )
        
        setViewControllers([homeViewController], animated: false)
        
        homeViewController.tabBarController?.navigationItem.title = "홈 타이틀"
        homeViewController.tabBarItem = UITabBarItem(title: "거래소", image: nil, tag: 0)
    }
}

