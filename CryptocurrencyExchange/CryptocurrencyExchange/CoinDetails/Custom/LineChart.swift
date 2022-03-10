//
//  LineChart.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/10.
//

import UIKit

class LineChart: UIView {
    func drawChart(data: [Double]) {
        let lineLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        let points = setPoints(data: data)
        linePath.move(to: points.first ?? CGPoint.zero)
        points.forEach { point in
            linePath.addLine(to: point)
        }
        
        lineLayer.strokeColor = UIColor.titleColor?.cgColor ?? UIColor.placeholderText.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.path = linePath.cgPath
        layer.addSublayer(lineLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        lineLayer.add(animation, forKey: "chartAnimation")

    }
    
    private func setPoints(data: [Double]) -> [CGPoint] {
        var result: [CGPoint] = []
        guard let max = data.max(),
              let min = data.min() else {
                  return [CGPoint.zero]
              }
        let xUnit = layer.frame.width / CGFloat(data.count)
        let yUnit = layer.frame.height / (max - min)
        
        for (index, data) in data.enumerated() {
            result.append(
                CGPoint(x: CGFloat(index) * xUnit,
                        y: (max - data) * yUnit)
            )
        }
        return result
    }
}
