//
//  ChartViewModel.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import UIKit
import Charts

class ChartViewModel {
    var dataEntries: Observable<CandleChartDataEntries?>
    var repository: CandleStickChartRepository

    init(dataEntries: Observable<CandleChartDataEntries?> = Observable(nil),
         repository: CandleStickChartRepository
    ) {
        self.dataEntries = dataEntries
        self.repository = repository
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
    func getCandleStickData(parameter: CandleStickParameters) {
        self.repository.getCandleStickData(
            parameter: parameter
        ) { stickValues in
                self.dataEntries.value = try? CandleChartDataEntries(with: stickValues)
            }
    }
}
