//
//  QuoteViewController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import UIKit

class QuoteViewController: ViewControllerInjectingViewModel<QuoteViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // parentViewController에서 didMove(toParent:) 메서드 함수 호출 후 불리는 곳입니다!
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

    }

    // parentViewController에서 willMove(toParent:) 메서드 함수 호출 후 불리는 곳입니다!
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

    }
    
}
