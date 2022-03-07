//
//  ChartByTimesViewController.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/3/22.
//

import UIKit
import RealmSwift
import Charts

class ChartByTimesViewController: ViewControllerInjectingViewModel<ChartByTimesViewModel> {

    @IBOutlet weak var intervalStackView: UIStackView!
    @IBOutlet weak var candleStickChartView: CandleStickChartByTimesView!
    @IBOutlet weak var barChartView: BarChartByTimesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        candleStickChartView.delegate = self
        barChartView.delegate = self
        
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
            self?.candleStickChartView.updateDataEntries(from: entryDatas)
            self?.barChartView.updateDataEntries(from: entryDatas)
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

extension ChartByTimesViewController: ChartViewUpdatable {
    /// 두 차트 중 하나의 차트의 transform을 변경시킬 때, 나머지 차트에도 똑같은 모양으로 변경되도록 함
    /// - Parameter chartView: 모양의 변경이 발생한 차트
    /// - Parameter with transform: 변경된 수치
    func chartViewDidChangeTransform(chartView: ChartViewBase, with transform: CGAffineTransform) {
        if let _ = chartView as? CandleStickChartView {
            barChartView.setTransform(with: transform)
        } else {
            candleStickChartView.setTransform(with: transform)
        }
    }

}
