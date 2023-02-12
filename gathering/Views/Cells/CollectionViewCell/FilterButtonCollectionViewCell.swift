//
//  FilterButtonCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-09.
//

import UIKit

class FilterButtonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterButtonCollectionViewCell"
    
    override var isSelected: Bool{
        willSet{
                super.isSelected = newValue
                if newValue
                {
                    self.layer.borderWidth = 1.0
                    self.layer.borderColor = UIColor.mainColor?.cgColor
                    self.backgroundColor = .mainColor
                }
                else
                {
                    self.layer.borderWidth = 0
                    self.backgroundColor = .secondarySystemBackground
                }
            }
    }
    
    private let filterTextLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(filterTextLabel)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 13
        filterTextLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                               padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        filterTextLabel.text = nil
    }
    
    func configure(with filterText:String){
        filterTextLabel.text = filterText
    }
    
    
    
}

