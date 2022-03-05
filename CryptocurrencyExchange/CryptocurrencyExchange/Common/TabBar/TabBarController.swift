//
//  TabBarController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/02/26.
//

import UIKit


class TabBarController: UITabBarController {
    
    var exchangeViewController: ViewControllerInNavigation = {
        let exchangeViewController = ExchangeViewController(
            viewModel: ExchangeViewModel(
                nibName: "ExchangeViewController"
            )
        )
//        exchangeViewController.title = "홈 타이틀"             // 타이틀이 없을경우 미호출

        return ViewControllerInNavigation(
            with: TabInformation(
                viewController: exchangeViewController,
                tabTitle: "거래소",
                image: UIImage(systemName: "plus") ?? UIImage() // 임시 이미지 입니다
            )
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewControllers()
    }
    
    private func configureViewControllers() {
        let viewControllersInNavigation = [exchangeViewController].map {
            $0.navigationControllerIncludingViewController()
        }
        setViewControllers(viewControllersInNavigation, animated: false)
    }
}
