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
        
        
        let entries = [1,2,300,4,5,60,7,8,900,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,280,29,30,31,32,330,34,35,36,37,38,39,400,41,42,43,44,45,46,47,480,70].enumerated().map { (index, value) -> BarChartDataEntry in
            BarChartDataEntry(x: Double(index), y: value*2)
        }
        
        let set1 = BarChartDataSet(entries: entries)
        set1.colors = ChartColorTemplates.material()
        set1.drawValuesEnabled = false
        set1.axisDependency = .right

        self.setChart(dataSet: set1)
        self.setChartZoom(totalCount: entries.count)
        
    }
    
    private func setChart(dataSet: BarChartDataSet) {
        let data = BarChartData(dataSet: dataSet)
        chartView.data = data
//        data.barWidth = 49
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
