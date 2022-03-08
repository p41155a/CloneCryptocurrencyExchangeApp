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
    var orderCurrency: OrderCurrency
    var paymentCurrency: PaymentCurrency
    var candleStickData: Observable<[CandleStickData]?>
    
    init(
        nibName: String?,
        repository: CandleStickChartRepository,
        orderCurrency: OrderCurrency,
        paymentCurrency: PaymentCurrency
    ) {
        self.nibName = nibName
        self.repository = repository
        self.orderCurrency = orderCurrency
        self.paymentCurrency = paymentCurrency
        self.candleStickData = Observable(nil)
    }
    
    /// 시간 간격별 데이터 최신화
    func updateCandleStickData() {
        TimeIntervalInChart.allCases.forEach { interval in
            self.getCandleStickData(
                intervalType: interval,
                shouldSetChartData: interval.rawValue == 0
            )
        }
    }
    
    private func candleStickParmeters(with intervalType: TimeIntervalInChart) -> CandleStickParameters {
        return CandleStickParameters(
            orderCurrency: self.orderCurrency,
            chartInterval: intervalType,
            paymentCurrency: self.paymentCurrency
        )
    }
    
    /// 레파지토리에 candleStick 데이터 반환 요청
    /// - Parameter intervalType: 요청할 시간 간격(1분/10분/30분/1시간/일)
    /// - Parameter shouldSetChartData: 차트에 보여줄 시간 간격일 경우 true. 데이터 업데이트만 필요할 경우 false.
    func getCandleStickData(
        intervalType: TimeIntervalInChart,
        shouldSetChartData: Bool = true
    ) {
        self.repository.getCandleStickData(
            parameter: candleStickParmeters(with: intervalType)
        ) { datas in
            if shouldSetChartData {
                self.candleStickData.value = datas
            }
        }
    }
    
    func candleStickData(at index: Int) -> CandleStickData? {
        guard let datas = self.candleStickData.value else {
            return nil
        }
        return datas[index]
    }
}
