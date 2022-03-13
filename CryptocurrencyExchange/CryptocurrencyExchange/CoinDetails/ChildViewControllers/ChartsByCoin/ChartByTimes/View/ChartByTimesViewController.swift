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
    @IBOutlet weak var coinInformationView: CoinInformationInChartView!
    let dateMarkerView = DateMarkerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        candleStickChartView.delegate = self
        barChartView.delegate = self
        
        setStackViewUI()
        bindObservables()
        
        self.view.addSubview(dateMarkerView)
        dateMarkerView.isHidden = true
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
            self?.coinInformationView.setUI(with: datas?.last)
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
        self.dateMarkerView.isHidden = true
    }
}

extension ChartByTimesViewController: ChartViewUpdatable {
    /// 두 차트 중 하나의 차트의 transform을 변경시킬 때, 나머지 차트에도 똑같은 모양으로 변경되도록 함
    /// - Parameter chartView: 모양의 변경이 발생한 차트
    /// - Parameter transform: 변경된 수치
    func chartViewDidChangeTransform(
        chartView: ChartViewBase,
        with transform: CGAffineTransform
    ) {
        if let _ = chartView as? CandleStickChartView {
            barChartView.setTransform(with: transform)
        } else {
            candleStickChartView.setTransform(with: transform)
        }
    }

    /// 캔들스틱을 선택할 때마다 왼쪽 상단에 시/고/저/종/변화량 정보 노출
    /// - Parameter x: 선택된 캔들스틱의 x 인덱스 전달
    /// - Parameter xPosition: 선택된 캔들스틱의 x 인덱스 전달
    /// - Parameter yPosition: 선택된 캔들스틱의 x 인덱스 전달

    func chartViewDidSelectCandleStick(
        at xValue: Double,
        xPosition: CGFloat,
        yPosition: CGFloat
    ) {
        guard let data = viewModel.candleStickData(at: Int(xValue)) else { return }
        self.coinInformationView.setUI(with: data)
        self.dateMarkerView.updateDateLabel(
            timeInterval: data.time,
            centerXPosition: xPosition,
            yPosition: self.barChartView.frame.maxY
        )
    }
}
