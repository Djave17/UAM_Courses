//
//  CircularProgressBar.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 30/1/25.
//

import UIKit

class CircularProgressBar: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        let radius = bounds.width / 2.5
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)

        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 3  // delgado
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        // animacion
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemTeal.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 3  // Más delgado
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0  // Inicialmente en 0%
        layer.addSublayer(progressLayer)
    }
    
    func setProgress(_ value: CGFloat, animated: Bool = true, duration: CFTimeInterval = 1.0) {
        let clampedValue = max(0, min(value, 1))
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = clampedValue
        animation.duration = animated ? duration : 0
        progressLayer.strokeEnd = clampedValue
        progressLayer.add(animation, forKey: "progressAnim")
    }
}
