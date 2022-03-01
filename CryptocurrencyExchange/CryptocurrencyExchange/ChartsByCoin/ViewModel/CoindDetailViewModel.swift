//
//  CoindDetailViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/01.
//

import Foundation

struct CoindDetailViewModel: XIBInformation {
    var nibName: String?
    
    init(nibName: String?) {
        self.nibName = nibName
    }
}
