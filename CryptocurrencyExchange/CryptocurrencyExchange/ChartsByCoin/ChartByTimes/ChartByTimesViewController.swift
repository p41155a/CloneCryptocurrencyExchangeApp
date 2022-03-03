//
//  ChartByTimesViewController.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/3/22.
//

import UIKit

class ChartByTimesViewController: ViewControllerInjectingViewModel<ChartByTimesViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        let chartView = ChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chartView)
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: self.view.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
