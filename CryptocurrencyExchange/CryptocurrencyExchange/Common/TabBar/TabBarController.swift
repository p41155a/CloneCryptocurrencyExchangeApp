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
//        exchangeViewController.title = "홈 타이틀"             // 타이틀이 없을경우 미호출

        return ViewControllerInNavigation(
            with: TabInformation(
                viewController: exchangeViewController,
                tabTitle: "거래소",
                image: UIImage(systemName: "plus") ?? UIImage() // 임시 이미지 입니다
            )
        )
    }()
    
    var coindDetailViewController: ViewControllerInNavigation = {
        let coinDetailViewController = CoinDetailViewController(
            viewModel: CoindDetailViewModel(
                nibName: "CoinDetailViewController"
            )
        )
        
        return ViewControllerInNavigation(
            with: TabInformation(
                viewController: coinDetailViewController,
                tabTitle: "코인",
                image: UIImage.checkmark // 임시 이미지 입니다
            )
        )
    }()
    
    // 실제 코인 상세 화면으로 쓰일 뷰컨트롤러입니다.
    // 접근을 쉽게 하기 위해 임시로 탭으로 추가합니다
    var coindDetailsViewController: ViewControllerInNavigation = {
        let coinDetailViewController = CoinDetailsViewController(
            viewModel: CoinDetailsViewModel(
                nibName: "CoinDetailsViewController",
                dependency: CoinDetailsDependency(
                    orderCurrency: "BTC",
                    paymentCurrency: "KRW"
                )
            )
        )
        
        return ViewControllerInNavigation(
            with: TabInformation(
                viewController: coinDetailViewController,
                tabTitle: "코인상세",
                image: UIImage.actions // 임시 이미지 입니다
            )
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        self.configureViewControllers()
    }
    
    private func configureViewControllers() {
        let viewControllersInNavigation = [
            coindDetailViewController,
            exchangeViewController,
            coindDetailsViewController
        ].map {
            $0.navigationControllerIncludingViewController()
        }
        setViewControllers(viewControllersInNavigation, animated: false)
    }
}
