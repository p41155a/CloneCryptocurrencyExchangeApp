//
//  CandleStickChartByTimesView.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import UIKit
import Charts

class CandleStickChartByTimesView: UIView {

    @IBOutlet weak var chartView: CandleStickChartView!
    
    var viewModel = CandleStickChartByTimesViewModel()
    var delegate: ChartViewUpdatable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let superView = Bundle.main.loadNibNamed("CandleStickChartByTimesView", owner: self, options: nil)?.first as! UIView
        self.addSubview(superView)
        superView.frame = self.bounds
        superView.layoutIfNeeded()
        
        self.setChartUI()
        self.bindClosures()
    }
    
    private func setChartUI() {
        chartView.delegate = self
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
        yAxisRight.minWidth = 72
        
        chartView.dragDecelerationEnabled = false
    }
     
    func updateDataEntries(from dbData: [CandleStickData]) {
        self.viewModel.updateEntries(from: dbData)
    }
    
    private func bindClosures() {
        self.viewModel.dataEntries.bind { [weak self] entries in
            guard let `self` = self else { return }
            guard let entryArr = entries?.values else { return }
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
        self.viewModel.setZoomFactors(totalCount: totalCount)
        let zoomFactor = viewModel.zoomFactor
        chartView.zoom(
            scaleX: zoomFactor.scaleX,
            scaleY: zoomFactor.scaleY,
            xValue: zoomFactor.xValue,
            yValue: zoomFactor.yValue,
            axis: .right
        )
    }
    
    func setTransform(with transfrom: CGAffineTransform) {
        chartView.viewPortHandler.refresh(newMatrix: transfrom, chart: chartView, invalidate: true)
    }
}

extension CandleStickChartByTimesView: ChartViewDelegate {
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        let currentMatrix = chartView.viewPortHandler.touchMatrix
        self.delegate?.chartViewDidChangeTransform(chartView: self.chartView, with: currentMatrix)
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        let currentMatrix = chartView.viewPortHandler.touchMatrix
        self.delegate?.chartViewDidChangeTransform(chartView: self.chartView, with: currentMatrix)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.delegate?.chartViewDidSelectCandleStick(at: entry.x)
    }
}
