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
        apiManager.assetsStatus { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }


}

