//
//  ChartByTimesViewController.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/3/22.
//

import UIKit
import RealmSwift

class ChartByTimesViewController: ViewControllerInjectingViewModel<ChartByTimesViewModel> {

    @IBOutlet weak var intervalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStackViewUI()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        self.viewModel.getCandleStickData(
            parameter: CandleStickParameters(
                orderCurrency: .appoint(name: "BTC"),
                paymentCurrency: .KRW,
                chartInterval: .oneMinute
            )
        )
    }
    
    // 각 시간간격 버튼의 tag, title, 버튼 event 설정
    private func setStackViewUI() {
        intervalStackView.arrangedSubviews.enumerated().forEach { (index, subview) in
            guard let button = subview as? IntervalButton else { return }
            guard let type = TimeIntervalInChart(rawValue: index) else { return }
            button.tag = index
            button.setTitle(type.title, for: .normal)
            button.addTarget(
                self,
                action: #selector(didTap(intervalButton:)),
                for: .touchUpInside
            )
        }
    }
    
    // 각 시간간격 버튼의 눌림 상태 업데이트
    @objc
    private func didTap(intervalButton: UIButton) {
        intervalStackView.arrangedSubviews.enumerated().forEach { (index, subview) in
            guard let button = subview as? UIButton else { return }
            button.isSelected = intervalButton.tag == index
        }
    }
}
