//
//  CryptocurrencyListViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import Foundation

class CryptocurrencyListViewModel: XIBInformation {
    var nibName: String?
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
}
