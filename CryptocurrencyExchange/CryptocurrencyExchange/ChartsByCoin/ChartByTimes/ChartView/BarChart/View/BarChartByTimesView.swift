//
//  BarChartByTimesView.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/06.
//

import UIKit
import Charts

class BarChartByTimesView: UIView {
    @IBOutlet weak var chartView: BarChartView!
    
    var viewModel = BarChartByTimesViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let superView = Bundle.main.loadNibNamed("BarChartByTimesView", owner: self, options: nil)?.first as! UIView
        self.addSubview(superView)
        superView.frame = self.bounds
        superView.layoutIfNeeded()
        
        self.setChartUI()
        self.bindClosures()
    }
    
    private func setChartUI() {
        chartView.dragEnabled = true
        chartView.scaleYEnabled = false
        chartView.autoScaleMinMaxEnabled = true

        let xAxis = chartView.xAxis
        xAxis.drawLabelsEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.gridColor = .systemGray6

        chartView.leftAxis.enabled = false
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelCount = 2
        rightAxis.xOffset = 25
        rightAxis.labelXOffset = -20
        rightAxis.axisMinimum = 0
        rightAxis.gridColor = .systemGray6
    }
    
    private func bindClosures() {
        self.viewModel.dataEntries.bind { [weak self] entries in
            guard let `self` = self else { return }
            guard let entryArr = entries else { return }
            let dataSet = BithumbBarDataSet(entryArr: entryArr)
            self.setChart(dataSet: dataSet)
            self.setChartZoom(totalCount: entryArr.values.count)
        }
    }
    
    func updateDataEntries(from dbData: [CandleStickData]) {
        self.viewModel.updateEntries(from: dbData)
    }
    
    private func setChart(dataSet: BarChartDataSet) {
        let data = BarChartData(dataSet: dataSet)
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
