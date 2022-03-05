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
    @IBOutlet weak var chartView: ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStackViewUI()
        bindObservables()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        self.viewModel.updateCandleStickData()
    }
    
    private func bindObservables() {
        self.viewModel.candleStickData.bind { [weak self] datas in
            guard let entryDatas = datas else { return }
            self?.chartView.updateDataEntries(from: entryDatas)
        }
    }
    
    // 각 시간간격 버튼의 tag, title, 버튼 event 설정
    private func setStackViewUI() {
        intervalStackView.arrangedSubviews.enumerated().forEach { (index, subview) in
            guard let button = subview as? IntervalButton else { return }
            guard let type = TimeIntervalInChart(rawValue: index) else { return }
            button.tag = index
            button.setTitle(type.title, for: .normal)
            button.isSelected = index == 0
            button.addTarget(
                self,
                action: #selector(didTap(intervalButton:)),
                for: .touchUpInside
            )
        }
    }
    
    // 1분/10분/30분/1시간/일 버튼의 눌림 이벤트 처리
    @objc
    private func didTap(intervalButton: UIButton) {
        intervalStackView.arrangedSubviews.enumerated().forEach { (index, subview) in
            guard let button = subview as? UIButton else { return }
            button.isSelected = intervalButton.tag == index
        }
        
        guard let intervalType = TimeIntervalInChart(rawValue: intervalButton.tag) else { return }
        self.viewModel.getCandleStickData(intervalType: intervalType)
    }
}
