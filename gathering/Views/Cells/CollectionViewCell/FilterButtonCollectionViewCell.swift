//
//  FilterButtonCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-09.
//

import UIKit

class FilterButtonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterButtonCollectionViewCell"
    
    private let normalTextColor:UIColor = .secondaryLabel
    
    override var isSelected: Bool{
        willSet{
                super.isSelected = newValue
                if newValue
                {
                    self.layer.borderWidth = 1.0
                    self.layer.borderColor = UIColor.mainColor?.cgColor
                    self.backgroundColor = .mainColor
                    self.filterTextLabel.textColor = .streamWhiteSnow
                }
                else
                {
                    self.layer.borderWidth = 0
                    self.backgroundColor = .streamWhiteSnow
                    self.filterTextLabel.textColor = normalTextColor
                }
            }
    }
    
    private let filterTextLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(filterTextLabel)
        backgroundColor = .streamWhiteSnow
        layer.cornerRadius = 13
        filterTextLabel.textColor = normalTextColor
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
    
    func configure(with object:Any){
        var title = ""
        switch object {
        case let location as Location:
            title = location.name
        case let eventDate as EventDate:
            title = eventDate.name
        default:
            break
        }
        filterTextLabel.text = title
    }
    
    
    
}

