//
//  CoinDetailsViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import Foundation

class CoinDetailsViewModel: XIBInformation {
    var nibName: String?
    var dependency: CryptocurrencyListTableViewEntity
    
    init(
        nibName: String?,
        dependency: CryptocurrencyListTableViewEntity
    ) {
        self.nibName = nibName
        self.dependency = dependency
    }
}
