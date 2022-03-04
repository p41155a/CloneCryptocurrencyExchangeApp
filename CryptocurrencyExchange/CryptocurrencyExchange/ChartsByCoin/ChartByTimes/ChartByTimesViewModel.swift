//
//  ChartByTimesViewModel.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/3/22.
//

import Foundation

class ChartByTimesViewModel: XIBInformation {
    var nibName: String?
    var repository: CandleStickChartRepository

    
    init(
        nibName: String?,
        repository: CandleStickChartRepository
    ) {
        self.nibName = nibName
        self.repository = repository
    }
    
    /// 레파지토리에 candleStick API 호출하도록 요청
    func getCandleStickData(parameter: CandleStickParameters) {
        self.repository.getCandleStickData(
            parameter: parameter
        ) { stickValues in
            // 추후 db에 저장해야 함
        }
    }
}
