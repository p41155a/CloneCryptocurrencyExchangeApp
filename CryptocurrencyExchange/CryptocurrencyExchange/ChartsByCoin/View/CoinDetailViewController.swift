//
//  CoinDetailViewController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import UIKit

// 작업을 하기 위해 임의로 코인별 상세 페이지를 만들었습니다
// 코인상세 화면과 같은 역할을 합니다
class CoinDetailViewController: ViewControllerInjectingViewModel<CoindDetailViewModel> {

    var chartViewController: ViewControllerInjectingViewModel<ChartByTimesViewModel> = {
        let viewController = ChartByTimesViewController(
            viewModel: ChartByTimesViewModel(
                nibName: "ChartByTimesViewController"
            )
        )
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildVC(chartViewController)
    }

    private func addChildVC(_ viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        viewController.didMove(toParent: self)
    }

}


