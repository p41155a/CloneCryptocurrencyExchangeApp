//
//  CoinDetailsViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import Foundation

class CoinDetailsViewModel: XIBInformation {
    var nibName: String?
    var dependency: CoinDetailsDependency
    
    init(
        nibName: String?,
        dependency: CoinDetailsDependency
    ) {
        self.nibName = nibName
        self.dependency = dependency
    }
}
