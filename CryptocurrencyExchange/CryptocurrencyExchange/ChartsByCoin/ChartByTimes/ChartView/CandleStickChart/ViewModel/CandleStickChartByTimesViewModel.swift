//
//  CandleStickChartByTimesViewModel.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import UIKit
import Charts

class CandleStickChartByTimesViewModel {
    var dataEntries: Observable<CandleChartDataEntries?>
    var zoomFactor: ChartZoomFactor
    
    init(
        dataEntries: Observable<CandleChartDataEntries?> = Observable(nil),
        zoomFactor: ChartZoomFactor = ChartZoomFactor(scaleX: 1.0, scaleY: 1.0, xValue: 0, yValue: 0)
    ) {
        self.dataEntries = dataEntries
        self.zoomFactor = zoomFactor
    }
    
    /// 차트를 보여줄 때 원하는 갯수만큼 보이도록 zoomFactor 계산
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
    
    func setZoomFactors(scaleX: CGFloat) {
        self.zoomFactor = ChartZoomFactor(
            scaleX: scaleX,
            scaleY: 1.0,
            xValue: self.zoomFactor.xValue,
            yValue: self.zoomFactor.yValue
        )
    }
    
    func updateEntries(from dbData: [CandleStickData]) {
        self.dataEntries.value = CandleChartDataEntries(dataFromDB: dbData)
    }
}
