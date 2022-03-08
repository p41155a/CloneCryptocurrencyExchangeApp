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
}
