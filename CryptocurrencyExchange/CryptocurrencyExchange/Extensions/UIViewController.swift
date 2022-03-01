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
