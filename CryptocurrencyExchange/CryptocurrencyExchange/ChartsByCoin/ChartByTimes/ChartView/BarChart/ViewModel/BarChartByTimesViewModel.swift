//
//  BarChartByTimesViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/06.
//

import UIKit

class BarChartByTimesViewModel {
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
}
