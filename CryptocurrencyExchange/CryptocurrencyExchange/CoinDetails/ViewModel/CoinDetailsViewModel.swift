//
//  CoinDetailsViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import Foundation

class CoinDetailsViewModel: XIBInformation {
    var nibName: String?
    
    init(nibName: String?) {
        self.nibName = nibName
    }
}
