//
//  GradientButton.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-27.
//

import UIKit

class GradientButton: UIButton {
    var gradientLayer: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        titleLabel?.font = .robotoRegularFont(ofSize: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer = self.gradientLayer {
            gradientLayer.frame = self.bounds
        }
        
        
    }
    
    func setGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        if let gradientLayer = self.gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
}
