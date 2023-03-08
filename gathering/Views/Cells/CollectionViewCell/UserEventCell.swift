//
//  UserEventCell.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-07.
//

import UIKit

class UserEventCell: UICollectionViewCell {
    
    private let dateLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 18)
        return view
    }()
    
    private let titleLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 16)
        return view
    }()
    
    private let locationLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 16)
        return view
    }()
    
    var userEvent:UserEvent? {
        didSet {
            guard let model = userEvent?.toViewModel() else {return}
            titleLabel.text = model.title
            
            dateLabel.text = model.date
            
            locationLabel.text = model.location
            
        }
    }
    
    static let identifier = "UserEventCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel,dateLabel,locationLabel].forEach({addSubview($0)})
        
        backgroundColor = .systemBackground
        
        dateLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        titleLabel.anchor(top: dateLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        locationLabel.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
