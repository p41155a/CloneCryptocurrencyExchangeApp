//
//  CryptocurrencyExchangeAPITests.swift
//  CryptocurrencyExchangeTests
//
//  Created by Yoojin Park on 2022/02/26.
//

import XCTest
import Alamofire
@testable import CryptocurrencyExchange

class CryptocurrencyExchangeAPITests: XCTestCase, APIProvider {
    func test_assetsstatus_BTC를_알맞은_Entity로_요청하면_정상코드() {
        let expectation = XCTestExpectation()
        fetchResponse(requestURL: setURLRequest(url: "https://api.bithumb.com/public/assetsstatus/BTC?")!, type: AppointedAssetsStatusEntity.self) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.status, "0000") // 정상: 0000, 그 외 에러 코드
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_assetsstatus_BTC를_ALL의_Entity로_요청하면_다른_포멧으로_요청했다고_에러출력() {
        let expectation = XCTestExpectation()
        fetchResponse(requestURL: setURLRequest(url: "https://api.bithumb.com/public/assetsstatus/BTC?")!, type: AssetsStatusEntity.self) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, APIError.incorrectFormat)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_assetsstatus에서_s가_하나빠진_없는_URL로_요청하면_bithumb에러_출력() {
        let expectation = XCTestExpectation()
        fetchResponse(requestURL: setURLRequest(url: "https://api.bithumb.com/public/assetstatus/BTC?")!, type: AppointedAssetsStatusEntity.self) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.debugDescription, "Bad Request.(Auth Data)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }


    // - MARK: private func
    private func setURLRequest(url: String) -> URLRequestConvertible? {
        guard let url: URL = URL(string: url) else { return nil }
        let request = URLRequest(url: url)
        
        return request
    }
}
