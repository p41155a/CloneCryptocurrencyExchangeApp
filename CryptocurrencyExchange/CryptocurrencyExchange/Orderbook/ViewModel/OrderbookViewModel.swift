//
//  OrderbookViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/04.
//

import Foundation

class OrderbookViewModel: XIBInformation {
    var nibName: String?
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
}
