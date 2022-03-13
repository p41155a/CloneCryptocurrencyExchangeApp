//
//  SortListButtonView.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/07.
//

import UIKit

class SortListButton: UIButton {
    var sortStandardLabel = UILabel()
    var sortMarkImageView = UIImageView()
    var orderBy: OrderBy? {
        didSet {
            changeImageForMark()
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
    
    func isClicked() {
        // 다른 곳을 클릭했다 처음 눌린것이라면(sort == nil) -> .desc
        // 이외에는 toggle
        self.orderBy = orderBy?.toggle() ?? .desc
    }
    
    private func configureUI() {
        sortStandardLabel.text = titleLabel?.text
        sortStandardLabel.tintColor = .contourColor
        sortStandardLabel.font = .systemFont(ofSize: 12)
        
        addSubview(sortStandardLabel)
        
        sortStandardLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortStandardLabel.topAnchor.constraint(equalTo: self.topAnchor),
            sortStandardLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        titleLabel?.isHidden = true
        
        sortMarkImageView.image = UIImage(named: "arrow")
        addSubview(sortMarkImageView)
        
        sortMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortMarkImageView.heightAnchor.constraint(equalToConstant: 12),
            sortMarkImageView.widthAnchor.constraint(equalToConstant: 11),
            sortMarkImageView.leadingAnchor.constraint(equalTo: sortStandardLabel.trailingAnchor),
            sortMarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        if self.contentHorizontalAlignment == .left {
            sortStandardLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        } else {
            sortMarkImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
    }
    
    private func changeImageForMark() {
        switch orderBy {
        case .asc:
            sortMarkImageView.image = UIImage(named: "arrowUp")
        case .desc:
            sortMarkImageView.image = UIImage(named: "arrowDown")
        default:
            sortMarkImageView.image = UIImage(named: "arrow")
        }
    }
}
