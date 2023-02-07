//
//  SectionHeaderCollectionReusableView.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-06.
//

import UIKit

struct SectionHeaderViewModel {
    let title:String
    let buttonText:String
}

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "SectionHeaderCollectionReusableView"
    
    private let titleLabel:UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.textColor = .label
        return view
    }()
    
    private let button:UIButton = {
        let view = UIButton()
        view.setTitleColor(.link, for: .normal)
        return view
    }()
    
    @objc var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(button)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,
                          padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        
        button.anchor(top: titleLabel.topAnchor, leading: nil, bottom: titleLabel.bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with vm:SectionHeaderViewModel) {
        titleLabel.text = vm.title
        button.setTitle(vm.buttonText, for: .normal)
    }
    
    
}
