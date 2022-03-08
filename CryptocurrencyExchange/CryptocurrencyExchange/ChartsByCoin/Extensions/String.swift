//
//  UILabel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/07.
//

import UIKit

extension String {
    func attributedString(
        rangeText: String,
        font: UIFont? = nil,
        fontColor: UIColor? = nil,
        lineSpacing: CGFloat? = nil
    ) -> NSMutableAttributedString {
        let labelAttributedStr = NSMutableAttributedString(string: self)
        
        if let fontStyle = font {
            labelAttributedStr.addAttributes(
                [.font:fontStyle],
                range: (self as NSString).range(of: rangeText))
        }
        
        if let lineSpace = lineSpacing {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            labelAttributedStr.addAttributes(
                [.paragraphStyle:style],
                range: NSMakeRange(0, (self.count))
            )
        }
        
        if let fontColor = fontColor {
            labelAttributedStr.addAttributes(
                [.foregroundColor:fontColor],
                range: (self as NSString).range(of: rangeText)
            )
        }
        
        return labelAttributedStr
    }
}
