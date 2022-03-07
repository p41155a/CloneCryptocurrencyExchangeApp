//
//  AssetsStatusViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/08.
//

import Foundation

class AssetsStatusViewModel: XIBInformation {
    var nibName: String?
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
}

