//
//  UIColor.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/02/28.
//
import UIKit

extension UIColor {
    /// background color - (205, 217, 217, 100%)
    class var backgroundColor: UIColor? {
        return UIColor(named: "backgroundColor")
    }
    
    /// base color - (215, 217, 217, 100%)
    class var baseColor: UIColor? {
        return UIColor(named: "baseColor")
    }
    
    /// contour color - (202, 204, 204, 100%)
    class var contourColor: UIColor? {
        return UIColor(named: "contourColor")
    }

    /// increasing color - (0, 0, 0, 100%)
    class var titleColor: UIColor? {
        return UIColor(named: "titleColor")
    }
    
    /// increasing color - (242, 68, 69, 100%)
    class var increasingColor: UIColor? {
        return UIColor(named: "increasingColor")
    }
    
    /// decreasing color - (70, 83, 255, 100%)
    class var decreasingColor: UIColor? {
        return UIColor(named: "decreasingColor")
    }
}
