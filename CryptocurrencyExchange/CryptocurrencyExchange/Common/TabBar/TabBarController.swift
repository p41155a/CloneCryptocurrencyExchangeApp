//
//  TabBarController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/02/26.
//

import UIKit


class TabBarController: UITabBarController {
    
    var exchangeViewController: ViewControllerInNavigation = {
        let exchangeViewController = CryptocurrencyListViewController(
            viewModel: CryptocurrencyListViewModel(
                nibName: "CryptocurrencyListViewController"
            )
        )

        return ViewControllerInNavigation(
            with: TabInformation(
                viewController: exchangeViewController,
                tabTitle: "거래소",
                image: UIImage(named: "tabButton1") ?? UIImage()
            )
        )
    }()
    
    var assetsStatusViewController: ViewControllerInNavigation = {
        let assetsStatusViewController = AssetsStatusViewController(
            viewModel: AssetsStatusViewModel(
                nibName: "AssetsStatusViewController"
            )
        )

        return ViewControllerInNavigation(
            with: TabInformation(
                viewController: assetsStatusViewController,
                tabTitle: "입출금",
                image: UIImage(named: "tabButton2") ?? UIImage()
            )
        )
    }()
    
    var orderbookViewController: ViewControllerInNavigation = {
        let orderbookViewController = OrderbookViewController(
            viewModel: OrderbookViewModel(
                nibName: "OrderbookViewController"
            )
        )
        
        return ViewControllerInNavigation(
            with: TabInformation(
                viewController: orderbookViewController,
                tabTitle: "호가창",
                image: UIImage.checkmark // 임시 이미지 입니다
            )
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .tabBarColor
        self.tabBar.tintColor = .titleColor
        self.configureViewControllers()
    }
    
    private func configureViewControllers() {
        let viewControllersInNavigation = [
            exchangeViewController,
            assetsStatusViewController
        ].map {
            $0.navigationControllerIncludingViewController()
        }
        setViewControllers(viewControllersInNavigation, animated: false)
    }
}
