//
//  BarChartByTimesViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/06.
//

import UIKit
import Charts

class BarChartByTimesViewModel {
    var dataEntries: Observable<BarChartDataEntries?>
    var zoomFactor: ChartZoomFactor

    init(
        dataEntries: Observable<BarChartDataEntries?> = Observable(nil),
        zoomFactor: ChartZoomFactor = ChartZoomFactor(scaleX: 1.0, scaleY: 1.0, xValue: 0, yValue: 0)
    ) {
        self.dataEntries = dataEntries
        self.zoomFactor = zoomFactor
    }
    
    func updateEntries(from dbData: [CandleStickData]) {
        self.dataEntries.value = BarChartDataEntries(dataFromDB: dbData)
    }
    
    func setZoomFactors(totalCount: Int, visibleNumOfSticks: Int = 30) {
        let scaleX: CGFloat = CGFloat(totalCount/visibleNumOfSticks)
        let xValue: CGFloat = CGFloat(totalCount - visibleNumOfSticks/2)
        self.zoomFactor = ChartZoomFactor(
            scaleX: scaleX,
            scaleY: 1.0,
            xValue: xValue,
            yValue: 0.0
        )
    }
    
    func setZoomFactor(with factor: ChartZoomFactor) {
        self.zoomFactor = factor
    }
}
