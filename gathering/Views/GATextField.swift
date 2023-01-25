//
//  GATextField.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-13.
//

import UIKit

class GATextField: UITextField {

    var name:String?
    
    private let label:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textColor = .gray
        return view
    }()
    
    private let bottomLine:CALayer = {
        let view = CALayer()
        view.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        view.borderWidth = 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        layer.addSublayer(bottomLine)
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        layer.cornerRadius = 10
        borderStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name:String){
        label.text = name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: -15, width: width, height: 20)
        bottomLine.frame = CGRect(x: 10, y: height-2, width: width-20, height: 2)
    }
    

}

