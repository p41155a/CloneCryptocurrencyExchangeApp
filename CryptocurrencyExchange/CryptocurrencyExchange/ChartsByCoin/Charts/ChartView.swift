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
    
    var dataEntries: [CandleChartDataEntry] = []
    
    lazy var dataSet: CandleChartDataSet = {
        let dataSet = CandleChartDataSet(entries: dataEntries)
        dataSet.axisDependency = .right
        dataSet.drawIconsEnabled = false
        dataSet.shadowColor = .darkGray
        dataSet.shadowWidth = 0.7
        dataSet.decreasingColor = UIColor.decreasingColor
        dataSet.decreasingFilled = true
        dataSet.increasingColor = UIColor.increasingColor
        dataSet.increasingFilled = true
        dataSet.barSpace = 0
        dataSet.drawValuesEnabled = false
        dataSet.highlightColor = .lightGray
        return dataSet
    }()
    
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
        self.dataEntries = self.chartData(10, range: 5)
        self.setChart(dataSet: self.dataSet)
    }
    
    private func setChartUI() {
        chartView.dragEnabled = true
        chartView.scaleYEnabled = false

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.gridColor = .systemGray6
        
        chartView.leftAxis.enabled = false

        let yAxisRight = chartView.rightAxis
        yAxisRight.drawGridLinesEnabled = false
        yAxisRight.enabled = true

    }
    
    private func chartData(_ count: Int, range: UInt32) -> [CandleChartDataEntry] {
        return (0..<count).map { (i) -> CandleChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(40) + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0
            
            return CandleChartDataEntry(
                x: Double(i),
                shadowH: val + high,
                shadowL: val - low,
                open: even ? val + open : val - open,
                close: even ? val - close : val + close,
                icon: nil
            )
        }
    }
    
    private func setChart(dataSet: CandleChartDataSet) {
        let data = CandleChartData(dataSet: dataSet)
        chartView.data = data
    }
}
