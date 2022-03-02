//
//  ChartView.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import UIKit
import Charts

class ChartView: UIView {

    @IBOutlet weak var chartView: CandleStickChartView!
    
    var viewModel = ChartViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let superView = Bundle.main.loadNibNamed("ChartView", owner: self, options: nil)?.first as! UIView
        self.addSubview(superView)
        superView.frame = self.bounds
        superView.layoutIfNeeded()
        
        self.setChartUI()
        self.viewModel.getCandleStickData()
        self.bindClosures()
    }
    
    private func setChartUI() {
        chartView.dragEnabled = true
        chartView.scaleYEnabled = false

        chartView.autoScaleMinMaxEnabled = true

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.gridColor = .systemGray6
        
        chartView.leftAxis.enabled = false

        let yAxisRight = chartView.rightAxis
        yAxisRight.gridColor = .systemGray6
        yAxisRight.enabled = true
        
    }
     
    private func bindClosures() {
        self.viewModel.dataEntries.bind { [weak self] entries in
            guard let `self` = self else { return }
            guard let entryArr = entries else { return }
            let dataSet = BithumbCandleChartDataSet(entryArr)
            self.setChart(dataSet: dataSet)
            self.setChartZoom(totalCount: entryArr.count)
        }
    }
    
    private func setChart(dataSet: CandleChartDataSet) {
        let data = CandleChartData(dataSet: dataSet)
        chartView.data = data
    }
    
    private func setChartZoom(totalCount: Int) {
        let zoomFactor = self.viewModel.zoomFactors(totalCount: totalCount)
        chartView.zoom(
            scaleX: zoomFactor.scaleX,
            scaleY: zoomFactor.scaleY,
            xValue: zoomFactor.xValue,
            yValue: zoomFactor.yValue,
            axis: .right
        )
    }
}
