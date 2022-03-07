//
//  CoinInformationInChartView.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/07.
//

import Foundation
import UIKit

class CoinInformationInChartView: UIView {
    @IBOutlet weak var infoStackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let superView = Bundle.main.loadNibNamed("CoinInformationInChartView", owner: self, options: nil)?.first as! UIView
        self.addSubview(superView)
        superView.frame = self.bounds
        superView.layoutIfNeeded()
    }
    
    func setUI(with stickData: CandleStickData?) {
        guard let data = stickData else { return }
                
        let difference =  data.close - data.open
        let isOverZero = data.close > data.open
        let fontColor = isOverZero ? UIColor.increasingColor : UIColor.decreasingColor

        let attributedTexts = attributedTexts(
            from: data,
            fontColor: fontColor
        )

        let ratio = String(format: "%.2f", difference / data.close * 100)
        let sign = SignSymbol(value: difference).description
        let diferenceText = String(format: "%.0f", difference)
        let differenceTexts = " \(sign)\(diferenceText) (\(sign)\(ratio)%)"
        let differenceAttirubted = differenceTexts.attributedString(
            rangeText: differenceTexts,
            fontColor: fontColor
        )
        
        let subviews = self.infoStackView.arrangedSubviews.compactMap({ $0 as? UILabel })
        
        let firstLineTexts = attributedTexts[0]
        firstLineTexts.append(attributedTexts[1])
        firstLineTexts.append(attributedTexts[2])
        subviews[0].attributedText = firstLineTexts
        
        let secondLineTexts = attributedTexts[3]
        secondLineTexts.append(differenceAttirubted)
        subviews[1].attributedText = secondLineTexts
    }
    
    private func attributedTexts(from data: CandleStickData, fontColor: UIColor?) -> [NSMutableAttributedString] {
        let displaying: [CoinInfoInChart] = [
            .si(data.open),
            .go(data.high),
            .jeo(data.low),
            .jong(data.close)
        ]
        

        return displaying.map { info -> NSMutableAttributedString in
            return info.texts.attributedString(
                rangeText: info.description,
                fontColor: fontColor
            )
        }
    }
}
