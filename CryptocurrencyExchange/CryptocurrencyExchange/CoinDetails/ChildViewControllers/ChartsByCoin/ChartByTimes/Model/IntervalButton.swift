//
//  CornerButton.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/3/22.
//

import Foundation
import UIKit

class IntervalButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = self.cornerRadius
            setNeedsDisplay()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .baseColor : .clear
            setNeedsDisplay()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    private func setUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
        self.backgroundColor = isSelected ? .baseColor : .backgroundColor
    }
}
