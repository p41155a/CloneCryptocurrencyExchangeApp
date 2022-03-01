//
//  TabButton.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

final class TabButton: UIButton {
    var bottomBar = UIView()
    
    override var isSelected: Bool {
        didSet {
            configureForSelect(isSelected: isSelected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    private func configureUI() {
        bottomBar.setCornerRadius(radius: 1)
        bottomBar.backgroundColor = .black
        
        addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        configureForSelect(isSelected: isSelected)
    }
    
    private func configureForSelect(isSelected: Bool) {
        bottomBar.isHidden = !isSelected
        titleLabel?.textColor = isSelected ? .black : .darkgrayColor
    }
}
