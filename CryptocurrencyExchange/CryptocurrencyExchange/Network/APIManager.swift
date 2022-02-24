//
//  APIRequest.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation
import Alamofire

class APIManager {
    func assetsStatus(orderCurrency: String, success: @escaping () -> (), failure: @escaping (APIError) -> ()) {
        guard let request = APIService.assetsStatus(orderCurrency: orderCurrency).setURLRequest() else {
            failure(.invalidURL)
            return
        }
        AF.request(request)
            .responseData { (response) in 
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSONDecoder().decode(APIResponse.self, from: data)
                        print(json)
                    } catch(let error) {
                        #warning("이 부분 try-catch 부분으로 throw 해주고 싶은데 어떻게 해야할까요?")
                        failure(.deserializationError(error: error))
                    }
                case .failure(let error):
                    failure(.deserializationError(error: error))
                }
        }
    }
}
struct APIResponse: Codable {
    let status: String
    let data: Asset
}

struct Asset: Codable {
    let deposit_status: Int
    let withdrawal_status: Int
}
