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
        self.drawCandleSticks()
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
    
    private func drawCandleSticks() {
        CandleStickAPIManager().candleStick(
            parameters: CandleStickParameters(
                orderCurrency: .appoint(name: "BTC"),
                paymentCurrency: .KRW,
                chartInterval: .oneMinute
            )) { result in
                switch result {
                case .success(let data):
                    self.dataEntries = self.chartData(from: data.data)
                    self.setChart(dataSet: self.dataSet)
                    
                default: break
                }
            }
    }
    
    private func chartData(from stickValues: [[StickValue]]) -> [CandleChartDataEntry] {
        return stickValues.enumerated().map { (index, value) -> CandleChartDataEntry in
            let high = value[3].value
            let low = value[4].value
            let open = value[1].value
            let close = value[2].value
            
            return CandleChartDataEntry(
                x: Double(index),
                shadowH: high,
                shadowL: low,
                open: open,
                close: close,
                icon: nil
            )
        }
    }
    
    private func setChart(dataSet: CandleChartDataSet) {
        let data = CandleChartData(dataSet: dataSet)
        chartView.data = data
    }
    
    
}
