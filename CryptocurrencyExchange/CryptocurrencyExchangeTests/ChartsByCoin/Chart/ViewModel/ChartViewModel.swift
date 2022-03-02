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
    
    override func setUpWithError() throws {
        viewModel = ChartViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_캔들스틱데이터를_파라미터로_전달하면_dataEntries가_업데이트된다() {
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
        #warning("setChartData 메서드가 private func이 됨에 따라 접근할 수 없는 문제 발생")
        viewModel.setChartData(from: [stickValue])
        
        // then
        let dataEntries = viewModel.dataEntries.value?.first
        XCTAssertEqual(highPrice, dataEntries?.high)
        XCTAssertEqual(lowPrice, dataEntries?.low)
        XCTAssertEqual(openPrice, dataEntries?.open)
        XCTAssertEqual(closePrice, dataEntries?.close)
    }

}
