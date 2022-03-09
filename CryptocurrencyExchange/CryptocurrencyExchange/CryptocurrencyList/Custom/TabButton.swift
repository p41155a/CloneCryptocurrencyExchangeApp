//
//  TabButton.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit

final class TabButton: UIButton {
    var bottomBar = UIView()
    
    var isChoice: Bool = false {
        didSet {
            configureForSelect(isSelected: isChoice)
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
        bottomBar.backgroundColor = .titleColor
        
        addSubview(bottomBar)
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        configureForSelect(isSelected: isSelected)
    }
    
    private func configureForSelect(isSelected: Bool) {
        bottomBar.isHidden = !isSelected
        titleLabel?.tintColor = isSelected ? .titleColor : .darkgrayColor
    }
}
