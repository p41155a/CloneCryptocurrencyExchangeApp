//
//  ViewController.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    var apiManager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiManager.assetsStatus(orderCurrency: "BTC", success: {}, failure: {_ in })
    }


}

