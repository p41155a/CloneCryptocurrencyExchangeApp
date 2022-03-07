//
//  SortListButtonView.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/07.
//

import UIKit

class SortListButtonView: UIView {
    @IBOutlet weak var sortStandardLabel: UILabel!
    @IBOutlet weak var sortMarkImageView: UIImageView!
    var sort: OrderBy? {
        didSet {
            changeImageForMark()
        }
    }
    
    func isClicked() {
        // 다른 곳을 클릭했다 처음 눌린것이라면(sort == nil) -> .desc
        // 이외에는 toggle
        sort = sort?.toggle() ?? .desc
    }
    
    private func changeImageForMark() {
        switch sort {
        case .asc:
            sortMarkImageView.image = UIImage(named: "arrowUp")
        case .desc:
            sortMarkImageView.image = UIImage(named: "arrowDown")
        default:
            sortMarkImageView.image = UIImage(named: "arrow")
        }
    }
}
