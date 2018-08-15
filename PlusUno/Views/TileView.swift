//
//  TileView.swift
//  PlusUno
//
//  Created by Mario Solano on 10/22/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

let kTileCornerRadius: CGFloat = 7.6

class TileView: UIView {
    
    private lazy var pulsatingLayer: CAShapeLayer = {
        let squarePath = UIBezierPath(roundedRect: bounds, cornerRadius: kTileCornerRadius)
        let pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = squarePath.cgPath
        pulsatingLayer.fillColor = backgroundColor?.cgColor
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.frame = bounds
        self.layer.addSublayer(pulsatingLayer)
        self.bringSubview(toFront: self.numberLabel)
        
        return pulsatingLayer
    }()
    
    func addPulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.065
        animation.duration = 0.35
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func removePulsatingLayer() {
        pulsatingLayer.removeAnimation(forKey: "pulsing")
    }
    
    lazy private var numberLabel: UILabel = {
        let inset = self.bounds.insetBy(dx: 5, dy: 5)
        let label = UILabel(frame: inset)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        self.addSubview(label)
        
        return label
    }()
    
    var value: Int? {
        didSet {
            guard let value = self.value else { return }
            numberLabel.text = "\(value)"
            setAppearance(AppearanceProvider(forValue: value))
        }
    }
    
    init(frame: CGRect, value: Int?) {
        super.init(frame: frame)
        layer.cornerRadius = kTileCornerRadius
        self.value = value
        if value != nil {
            numberLabel.text = "\(value!)"
            setAppearance(AppearanceProvider(forValue: value!))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAppearance(_ appearance: AppearanceProvider) {
        backgroundColor = appearance.tileColor
        numberLabel.font = appearance.font
        numberLabel.textColor = appearance.labelColor
    }

}
