//
//  CoinDetailViewController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import UIKit

// 작업을 하기 위해 임의로 코인별 상세 페이지를 만들었습니다
class CoinDetailViewController: ViewControllerInjectingViewModel<CoindDetailViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view.frame
        let chartView = ChartView(
            frame: CGRect(
                origin: CGPoint(x: 0, y: 100),
                size: CGSize(width: UIScreen.main.bounds.width, height: view.height - 250)
            )
        )
        self.view.addSubview(chartView)
    }


}


