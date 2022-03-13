//
//  StarButton.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/06.
//

import UIKit

class StarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        self.setImage(UIImage(named: "starIcon"), for: .normal)
        self.setImage(UIImage(named: "starClickedIcon"), for: .selected)
    }
}
