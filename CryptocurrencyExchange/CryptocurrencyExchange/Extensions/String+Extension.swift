//
//  String+Extension.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/04.
//

import UIKit

extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    
    func setNumStringForm(isDecimalType: Bool = false, isMarkPlusMiuns: Bool = false) -> String {
        guard let doubleValue = doubleValue else {
            return self
        }
        var result: String = self
        if isDecimalType {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            result = numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        if isMarkPlusMiuns {
            result = doubleValue > 0 ? "+\(result)" : result
        }
        return result
    }
    
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
