//
//  SectionHeaderCollectionReusableView.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-06.
//

import UIKit

struct SectionHeaderViewModel {
    let title:String
    let buttonText:String?
}

protocol HomeSectionHeaderReusableViewDelegate:AnyObject {
    func HomeSectionHeaderReusableViewDidTapShowAll(_ view: HomeSectionHeaderReusableView, button:UIButton)
}

class HomeSectionHeaderReusableView: UICollectionReusableView {
    static let identifier = "SectionHeaderCollectionReusableView"
    
    weak var delegate:HomeSectionHeaderReusableViewDelegate?
    
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(button)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,
                          padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        
        button.anchor(top: titleLabel.topAnchor, leading: nil, bottom: titleLabel.bottomAnchor, trailing: trailingAnchor)
        button.addTarget(self, action: #selector(didTapShowAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with vm:SectionHeaderViewModel) {
        titleLabel.text = vm.title
        button.setTitle(vm.buttonText, for: .normal)
        button.layer.name = vm.buttonText
    }
    
    
    @objc private func didTapShowAll(){
        delegate?.HomeSectionHeaderReusableViewDidTapShowAll(self, button: button)
    }
    
    
}
