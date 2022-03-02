//
//  ChartViewModel.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import UIKit
import Charts

class ChartViewModel {
    var dataEntries: Observable<[CandleChartDataEntry]?>
    var repository: ProductionCandleStickRepository

    init(dataEntries: Observable<[CandleChartDataEntry]?> = Observable(nil),
         repository: ProductionCandleStickRepository = ProductionCandleStickRepository()
    ) {
        self.dataEntries = dataEntries
        self.repository = repository
    }
    
    /// 서버데이터를 차트를 그리는데 필요한 데이터 형태로 업데이트
    private func setChartData(from stickValues: [[StickValue]]) {
        self.dataEntries.value = stickValues.enumerated().map { (index, value) -> CandleChartDataEntry in
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
    
    /// 차트를 보여줄 때 원하는 갯수만큼 보이도록 zoomFactor 계산
    func zoomFactors(totalCount: Int, visibleNumOfSticks: Int = 30) -> ChartZoomFactor {
        let scaleX: CGFloat = CGFloat(totalCount/visibleNumOfSticks)
        let xValue: CGFloat = CGFloat(totalCount - visibleNumOfSticks/2)
        return ChartZoomFactor(
            scaleX: scaleX,
            scaleY: 1.0,
            xValue: xValue,
            yValue: 0.0
        )
    }
    
    /// 레파지토리에 candleStick API 호출하도록 요청
    func getCandleStickData() {
        self.repository.getCandleStickData(
            parameter: CandleStickParameters(
                orderCurrency: .appoint(name: "BTC"),
                paymentCurrency: .KRW,
                chartInterval: .oneMinute
            )) { stickValues in
                self.setChartData(from: stickValues)
            }
    }
}
