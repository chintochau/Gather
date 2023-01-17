//
//  GAButton.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-16.
//

import UIKit

class GAButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainColor
        layer.cornerRadius = 15
        tintColor = .white
        titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    

}
