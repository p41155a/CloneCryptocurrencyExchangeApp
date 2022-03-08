//
//  DateMarkerView.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/8/22.
//

import UIKit
import Charts

class DateMarkerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let superView = Bundle.main.loadNibNamed("DateMarkerView", owner: self, options: nil)?.first as! UIView
        self.addSubview(superView)
        superView.frame = self.bounds
        superView.layoutIfNeeded()
        
        self.frame = CGRect(x: 0, y: 0, width: 125, height: 23)
    }
}
