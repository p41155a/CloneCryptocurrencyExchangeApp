//
//  AssetsStatusViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/08.
//

import Foundation

class AssetsStatusViewModel: XIBInformation {
    private var apiManager = AssetsAPIManager()
    var assetsStatus: [String: EachAccountStatus] = [:]
    let accountList: Observable<[String]> = Observable([])
    let error: Observable<String?> = Observable(nil)
    var nibName: String?
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
    
    func fetchData() {
        apiManager.fetchAssetsStatus { [weak self] result in
            switch result {
            case .success(let data):
                self?.accountList.value = data.keys.map { $0 }
                self?.assetsStatus = data
            case .failure(let error):
                self?.error.value = error.debugDescription
            }
        }
    }
}

