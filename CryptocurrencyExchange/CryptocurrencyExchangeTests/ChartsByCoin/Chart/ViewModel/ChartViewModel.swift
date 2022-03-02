//
//  ChartViewModelTests.swift
//  CryptocurrencyExchangeTests
//
//  Created by 정다연 on 3/2/22.
//

import XCTest
@testable import CryptocurrencyExchange

class ChartViewModelTests: XCTestCase {

    var viewModel: ChartViewModel!
    var repository: MockCandleStickRepository!
    
    override func setUpWithError() throws {
        repository = MockCandleStickRepository()
        viewModel = ChartViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        repository = nil
        viewModel = nil
    }

    func test_캔들스틱데이터를_파라미터로_초기화하면_CandleChartDataEntries인스턴스가_생성된다() {
        // given
        let highPrice: Double = 52503000
        let lowPrice: Double = 52463000
        let openPrice: Double = 52467000
        let closePrice: Double = 52493000
        
        // when
        let stickValue = [
            1646110560000,
            openPrice,
            closePrice,
            highPrice,
            lowPrice,
            1.78628663
        ].map({ StickValue(value: $0) })

        
        // then
        let dataEntries = try? CandleChartDataEntries(with: [stickValue])?.values.first
        XCTAssertEqual(highPrice, dataEntries?.high)
        XCTAssertEqual(lowPrice, dataEntries?.low)
        XCTAssertEqual(openPrice, dataEntries?.open)
        XCTAssertEqual(closePrice, dataEntries?.close)
    }
    
    
    func test_레파지토리에_candleStickData를_요청하면_url_path가_생성된다() {
        // given
        let orderCurrencyText = "BTC"
        let paymentCurrency = paymentCurrency.KRW
        let interval = CandleStickIntervals.oneMinute
        
        let parameters = CandleStickParameters(
            orderCurrency: .appoint(name: orderCurrencyText),
            paymentCurrency: paymentCurrency,
            chartInterval: interval
        )

        // when
        viewModel.getCandleStickData(parameter: parameters)

        // then
        let params = repository.parameters()
        XCTAssertEqual(params?.path(), "\(orderCurrencyText)_\(paymentCurrency.value)/\(interval.rawValue)")

    }

}
