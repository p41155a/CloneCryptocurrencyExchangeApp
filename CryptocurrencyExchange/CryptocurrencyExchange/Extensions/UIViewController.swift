//
//  UIViewController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/02/26.
//

import Foundation
import UIKit

extension UIViewController {
    func push(
        to viewController: UIViewController,
        animated: Bool = true
    ) {
        self.navigationController?.pushViewController(
            viewController,
            animated: animated
        )
    }
    
    func showAlert(title: String,
                   message: String? = nil,
                   okAction: ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)?) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func popViewController(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func present(
        to viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        self.present(
            viewController,
            animated: animated,
            completion: completion
        )
    }
    
    func dismiss(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        self.presentingViewController?.dismiss(
            animated: animated,
            completion: completion
        )
    }
}
