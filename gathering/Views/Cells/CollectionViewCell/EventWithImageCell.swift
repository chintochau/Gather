//
//  EventSmallCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import IGListKit

final class EventWithImageCell: BasicEventCollectionViewCell {
    
    static let identifier = "EventWithImageCell"
    
    private let nameLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    
    private let tagStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.alignment = .top
        view.spacing = 1
        return view
    }()
    
    private let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let genderSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(separatorView)
        addSubview(genderSeparatorView)
        
        [].forEach({tagStackView.addArrangedSubview($0)})
        addSubview(tagStackView)
        
        
        
        let eventImageSize:CGFloat = width/4.3
        let eventImageHeight:CGFloat = eventImageSize*1.3
        eventImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                              padding: .init(top: 15, left: 20, bottom: 0, right: 0),
                              size: .init(width: eventImageSize, height: eventImageHeight))
        
        tagStackView.anchor(top: eventImageView.topAnchor, leading: eventImageView.trailingAnchor, bottom: nil, trailing:nil,
                            padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        tagStackView.trailingAnchor.constraint(lessThanOrEqualTo:  femaleIconImageView.leadingAnchor,constant: -10).isActive = true
        
        
        // MARK: - Gender Icons
        let smallIconSize:CGFloat = 17
        femaleIconImageView.anchor(top: eventImageView.topAnchor, leading: nil, bottom: nil, trailing: nil,
                                   padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                                   size: .init(width: smallIconSize, height: smallIconSize))
        
        femaleNumber.anchor(top: femaleIconImageView.topAnchor, leading: femaleIconImageView.trailingAnchor, bottom: femaleIconImageView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 6, bottom: 0, right: 0))
        
        genderSeparatorView.anchor(top: femaleIconImageView.topAnchor, leading: femaleNumber.trailingAnchor, bottom: maleIconImageView.bottomAnchor, trailing: maleIconImageView.leadingAnchor, padding: .init(top:  0, left: 7, bottom: 0, right: 7),size: .init(width: 2, height: 0))
        
        maleIconImageView.anchor(top: femaleIconImageView.topAnchor, leading: nil, bottom: nil, trailing: nil,
                                 padding: .init(top: 2, left: 0, bottom: 0, right: 5),
                                 size: .init(width: smallIconSize, height: smallIconSize))
        maleNumber.anchor(top: femaleIconImageView.topAnchor, leading: maleIconImageView.trailingAnchor, bottom: femaleIconImageView.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 6, bottom: 0, right: 20))
        
        
        // MARK: - Info Text
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: femaleIconImageView.bottomAnchor).isActive = true
        titleLabel.anchor(top: tagStackView.bottomAnchor, leading: tagStackView.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        dateLabel.anchor(top: titleLabel.bottomAnchor, leading: tagStackView.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 7, left: 0, bottom: 0, right: 0))
        locationLabel.anchor(top: dateLabel.bottomAnchor, leading: tagStackView.leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 0, left: 20, bottom: 0, right: 20),size: .init(width: 0, height: 2))
        separatorView.topAnchor.constraint(greaterThanOrEqualTo: eventImageView.topAnchor,constant: 14 + eventImageHeight).isActive = true
        separatorView.topAnchor.constraint(greaterThanOrEqualTo: locationLabel.bottomAnchor,constant: 13).isActive = true
        
        
        // MARK: - Profile image
        let profileImageSize:CGFloat = 35
        profileImageview.anchor(top: separatorView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,
                                padding: .init(top: 7, left: 20, bottom: 7, right: 0),
                                size: .init(width: profileImageSize, height: profileImageSize))
        profileImageview.layer.cornerRadius = profileImageSize/2
        
        profileTitleLabel.anchor(top: nil, leading: profileImageview.trailingAnchor, bottom: nil, trailing: nil,
                                 padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        profileTitleLabel.centerYAnchor.constraint(equalTo: profileImageview.centerYAnchor).isActive = true
        
        
        friendsNumber.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        friendsNumber.centerYAnchor.constraint(equalTo: profileTitleLabel.centerYAnchor).isActive = true
        
        totalNumber.anchor(top: femaleNumber.topAnchor, leading: nil, bottom: nil, trailing: femaleIconImageView.leadingAnchor,
                           padding: .init(top: 0, left: 0, bottom: 0, right: 5))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        tagStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
    }
    
    
    
    override func bindViewModel(_ viewModel: Any) {
        super.bindViewModel(viewModel)
        guard let vm = viewModel as? EventHomeCellViewModel else {return}
        
        
        vm.tag.prefix(2).forEach { tag in
            let tagLabel = TagLabel()
            tagLabel.eventTag = tag
            tagStackView.addArrangedSubview(tagLabel)
        }
        

    }
    
}

class TagLabel:UILabel {
    
    private let tagLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 14)
        return view
    }()
    
    private let backgroundView:UIView = {
        let view = UIView()
        return view
    }()
    
    var eventTag:Tag? {
        didSet{
            guard let eventTag = eventTag else {return}
            tagLabel.text = eventTag.tagString
            backgroundColor = eventTag.color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tagLabel)
        
        layer.cornerRadius = 7
        layer.masksToBounds = true
        
        tagLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
