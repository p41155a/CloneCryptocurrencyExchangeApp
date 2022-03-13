//
//  LineChart.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/10.
//

import UIKit

class LineChart: UIView {
    func drawChart(data: [Double], duration: Double = 2.0) {
        let points = setPoints(data: data)
        let animationDuration = duration / Double(data.count)
        var previousPoint = points.first ?? CGPoint.zero
        for (index, point) in points.enumerated() {
            let linePath = drawLine(previousPoint: previousPoint, nextPoint: point)
            let strokeColor = strokeColor(prePoint: previousPoint, currentPoint: point)
            let lineLayer = makeLayer(from: linePath, strokeColor: strokeColor)
            let time = Double(index) * animationDuration
            
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { (timer) in
                self.layer.addSublayer(lineLayer)
            }
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = animationDuration
            lineLayer.add(animation, forKey: "drawChart\(index)")
            previousPoint = point
        }
    }
    
    private func drawLine(previousPoint: CGPoint, nextPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: previousPoint)
        path.addLine(to: nextPoint)
        return path
    }
    
    private func makeLayer(from path: UIBezierPath, strokeColor: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.strokeColor = strokeColor
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        return layer
    }
    
    private func strokeColor(prePoint: CGPoint, currentPoint: CGPoint) -> CGColor {
        let isDecreasing = prePoint.y < currentPoint.y
        let color: UIColor = isDecreasing ? (.decreasingColor ?? .blue) : (.increasingColor ?? .red)
        return color.cgColor
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
