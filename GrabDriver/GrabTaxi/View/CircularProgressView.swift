//
//  CircularProgressView.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 06/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    // MARK: - Properties
    
    var progressLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCircleLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    private func configureCircleLayers() {
        pulsatingLayer = circleShapeLayer(strokeColor: .clear, fillColor: .rgb(red: 0, green: 184, blue: 60))
        layer.addSublayer(pulsatingLayer)
        
        trackLayer = circleShapeLayer(strokeColor: .rgb(red: 0, green: 160, blue: 36), fillColor: .clear)
        layer.addSublayer(trackLayer)
        
        progressLayer = circleShapeLayer(strokeColor: .rgb(red: 255, green: 255, blue: 255), fillColor: .clear)
        layer.addSublayer(progressLayer)
    }
    
    private func circleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: self.frame.width / 2, startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 12
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = center
        
        return layer
    }
    
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.25
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func animateProgress(duration: TimeInterval, completion: @escaping() -> Void) {
        animatePulsatingLayer()
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 1
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        progressLayer.strokeEnd = 0
        progressLayer.add(animation, forKey: "progress")
        
        CATransaction.commit()
    }
}
