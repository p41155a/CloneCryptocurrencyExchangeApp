//
//  DateMarkerView.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/8/22.
//

import UIKit
import Charts

class DateMarkerView: UIView {
    @IBOutlet weak var dateLabel: UILabel!
    
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
        
        self.frame = CGRect(x: 0, y: 0, width: 132, height: 23)
    }
    
    func updateDateLabel(
        timeInterval: Double,
        centerXPosition: CGFloat,
        yPosition: CGFloat
    ) {
        self.isHidden = false
        self.setUI(with: timeInterval)
        self.frame = self.frameToBeUnderBarChartView(
            centerXPosition: centerXPosition,
            yPosition: yPosition
        )
    }
    
    private func setUI(with timeInterval: Double) {
        self.dateLabel.text = Date(timeIntervalSince1970: timeInterval).toString()
        self.layoutIfNeeded()
    }
    
    private func frameToBeUnderBarChartView(
        centerXPosition: CGFloat,
        yPosition: CGFloat
    ) -> CGRect {
        return CGRect(
            origin: CGPoint(
                x: centerXPosition - self.frame.width/2,
                y: yPosition
            ),
            size: self.frame.size
        )
    }
}
