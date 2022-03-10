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
        var prepoint = points.first ?? CGPoint(x: 0, y: 0)
        linePath.move(to: prepoint)
        points.forEach { point in
            linePath.addLine(to: point)
            lineLayer.strokeColor = strokeColor(prePoint: prepoint, currentPoint: point)
            prepoint = point
        }
        
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.path = linePath.cgPath
        layer.addSublayer(lineLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        lineLayer.add(animation, forKey: "chartAnimation")

    }
    
    private func strokeColor(prePoint: CGPoint, currentPoint: CGPoint) -> CGColor {
        let isDecreasing = prePoint.y > currentPoint.y
        let color: UIColor = isDecreasing ? (.decreasingColor ?? .blue) : (.increasingColor ?? .red)
        return color.cgColor
    }
    
    private func setPoints(data: [Double]) -> [CGPoint] {
        var result: [CGPoint] = []
        guard let max = data.max(),
              let min = data.min() else {
                  return [CGPoint(x: 0, y: 0)]
              }
        let xUnit = layer.frame.width / CGFloat(data.count)
        let yUnit = layer.frame.height / (max - min)
        
        for (index, data) in data.enumerated() {
            result.append(
                CGPoint(x: CGFloat(index) * xUnit,
                        y: layer.frame.height - (data * yUnit))
            )
        }
        return result
    }
}
