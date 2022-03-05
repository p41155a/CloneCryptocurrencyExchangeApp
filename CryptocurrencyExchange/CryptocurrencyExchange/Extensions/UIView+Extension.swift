//
//  UIView+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

extension UIView: NibLoadable {
    func setCornerRadius(radius: CGFloat, masksToBounds: Bool = true) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = masksToBounds
    }
}

protocol NibLoadable {
    static func loadFromNib() -> Self?
}
extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self? {
        let identifier = String(describing: self)
        let view = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first
        return view as? Self
    }
}
