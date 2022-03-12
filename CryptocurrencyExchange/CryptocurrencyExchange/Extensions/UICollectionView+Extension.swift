//
//  UICollectionView+Extension.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/10/22.
//

import UIKit

extension UICollectionViewCell {
    static func register(collectionView: UICollectionView) {
        let Nib = UINib(nibName: self.NibName, bundle: nil)
        collectionView.register(Nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableCell(
        collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> Self {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath
        ) as? Self else {
            fatalError("Error! \(self.reuseIdentifier)")
        }
        
        return cell
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var NibName: String {
        return String(describing: self)
    }
}
