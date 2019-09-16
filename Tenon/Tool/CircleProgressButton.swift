//
//  CircleProgressButton.swift
//  TenonVPN
//
//  Created by friend on 2019/9/12.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class CircleProgress: UIView {
    var proEndgress: Float = 0 {
        didSet {
            if let layer = self.shapelayer {
                
                layer.strokeEnd = CGFloat(self.proEndgress)
            }
        }
    }
    var proStartgress: Float = 0 {
        didSet {
            if let layer = self.shapelayer {
                layer.strokeStart = CGFloat(proStartgress)
                if layer.strokeStart > 1.0{
                    self.shapelayer.removeFromSuperlayer()
                    self.shapelayer.removeAllAnimations()
                    self.shapelayer = addLayer()
                }
            }
        }
    }
    private var shapelayer: CAShapeLayer!
    
    func addLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.lineWidth = 10 // 圆弧的宽度
        layer.fillColor = nil // 填充颜色为空
        layer.strokeColor = UIColor(rgb: 0xE4E2E3).cgColor // 描边颜色
        let b = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 6, dy: 6)) // 贝塞尔路径
        b.apply(CGAffineTransform(translationX: -self.bounds.width / 2, y: -self.bounds.height / 2))
        b.apply(CGAffineTransform(rotationAngle: -.pi/2.0))
        b.apply(CGAffineTransform(translationX: self.bounds.width / 2, y: self.bounds.height / 2))
        
        layer.path = b.cgPath
        layer.zPosition = -1
        layer.strokeStart = 0
        layer.strokeEnd = 0 // 使用这个模拟进度
        self.layer.addSublayer(layer)
        return layer
    }
    public func setLayerColor(color:UIColor) {
        self.shapelayer.strokeColor = color.cgColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shapelayer = addLayer()
    }
}
