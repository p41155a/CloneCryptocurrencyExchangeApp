//
//  ChartViewUpdatable.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/07.
//

import UIKit
import Charts

protocol ChartViewUpdatable {
    /// 차트뷰를 zoom 하거나, drag하여 형태를 변경할 때 호출
    func chartViewDidChangeTransform(chartView: ChartViewBase, with transfrom: CGAffineTransform)
    
    /// 차트뷰 내의 캔들스틱을 선택할 때마다 호출
    func chartViewDidSelectCandleStick(at xValue: Double, xPosition: CGFloat, yPosition: CGFloat)
}
