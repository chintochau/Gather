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
        view.axis = .horizontal
        view.distribution = .fillProportionally
        // Add padding around the items
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(separatorView)
        
        [].forEach({tagStackView.addArrangedSubview($0)})
        
        
        let emojiSize:CGFloat = BasicEventCollectionViewCell.generalIconSize
        let padding:CGFloat = 10
        
        addSubview(tagStackView)
        
        let eventImageSize:CGFloat = width/4.3
        eventImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                              padding: .init(top: 15, left: 20, bottom: 0, right: 0),
                              size: .init(width: eventImageSize, height: eventImageSize*1.3))
        
        tagStackView.anchor(top: eventImageView.topAnchor, leading: eventImageView.trailingAnchor, bottom: nil, trailing: femaleIconImageView.leadingAnchor,
                            padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        
        // MARK: - Gender Icons
        let smallIconSize:CGFloat = 25
        femaleIconImageView.anchor(top: eventImageView.topAnchor, leading: nil, bottom: nil, trailing: nil,
                                   padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                                   size: .init(width: smallIconSize, height: smallIconSize))
        
        femaleNumber.anchor(top: femaleIconImageView.topAnchor, leading: femaleIconImageView.trailingAnchor, bottom: femaleIconImageView.bottomAnchor, trailing: nil)
        
        maleIconImageView.anchor(top: femaleIconImageView.topAnchor, leading: femaleNumber.trailingAnchor, bottom: nil, trailing: nil,
                                 padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                                 size: .init(width: smallIconSize, height: smallIconSize))
        maleNumber.anchor(top: femaleIconImageView.topAnchor, leading: maleIconImageView.trailingAnchor, bottom: femaleIconImageView.bottomAnchor, trailing: trailingAnchor)
        
        
        // MARK: - Info Text
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: femaleIconImageView.bottomAnchor).isActive = true
        titleLabel.anchor(top: tagStackView.bottomAnchor, leading: tagStackView.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        dateLabel.anchor(top: titleLabel.bottomAnchor, leading: tagStackView.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 7, left: 0, bottom: 0, right: 0))
        locationLabel.anchor(top: dateLabel.bottomAnchor, leading: tagStackView.leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 0, left: 20, bottom: 0, right: 20),size: .init(width: 0, height: 2))
        separatorView.topAnchor.constraint(greaterThanOrEqualTo: eventImageView.bottomAnchor,constant: 15).isActive = true
        separatorView.topAnchor.constraint(greaterThanOrEqualTo: locationLabel.bottomAnchor,constant: 15).isActive = true
        
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
        
        
        
        //
        //        profileImageview.anchor(
        //            top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
        //            padding: .init(top: 5, left: 10, bottom: 0, right: 0),
        //            size: CGSize(width: emojiSize, height: emojiSize))
        //        profileImageview.layer.cornerRadius = emojiSize/2
        //
        //        profileTitleLabel.anchor(
        //            top: profileImageview.topAnchor, leading: profileImageview.trailingAnchor, bottom: profileImageview.bottomAnchor, trailing: nil,
        //            padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        //
        //        tagStackView.anchor(top: profileImageview.bottomAnchor, leading: leadingAnchor, bottom: titleLabel.topAnchor, trailing: trailingAnchor)
        //
        //
        //        titleLabel.anchor(
        //            top: nil, leading: eventImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor,
        //            padding: .init(top: 0, left: padding, bottom: 0, right: padding))
        //
        //
        //        introLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: padding, right: padding))
        //
        //
        //        // MARK: - Gender separated
        //
        //        let imageSize:CGFloat = BasicEventCollectionViewCell.iconSize
        //        maleIconImageView.anchor(top: profileImageview.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5),size: CGSize(width: imageSize, height: imageSize))
        //
        //        femaleIconImageView.anchor(top: maleIconImageView.bottomAnchor, leading: maleIconImageView.leadingAnchor, bottom: nil, trailing: nil,size: CGSize(width: imageSize, height: imageSize))
        //
        //
        //        maleNumber.sizeToFit()
        //        maleNumber.anchor(top: maleIconImageView.topAnchor, leading: nil, bottom: maleIconImageView.bottomAnchor, trailing: maleIconImageView.leadingAnchor)
        //
        //        femaleNumber.sizeToFit()
        //        femaleNumber.anchor(top: femaleIconImageView.topAnchor, leading: nil, bottom: femaleIconImageView.bottomAnchor, trailing: femaleIconImageView.leadingAnchor)
        //
        //        // MARK: - all gender
        //
        //        let totalImageSize:CGFloat = BasicEventCollectionViewCell.generalIconSize/1.5
        //        totalIconImageView.anchor(top: profileImageview.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 10),size: CGSize(width: totalImageSize, height: totalImageSize))
        //
        //        totalNumber.sizeToFit()
        //        totalNumber.anchor(top: totalIconImageView.topAnchor, leading: nil, bottom: totalIconImageView.bottomAnchor, trailing: totalIconImageView.leadingAnchor
        //                           ,padding: .init(top: 0, left: 0, bottom: 0, right: 5))
        //
        //
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    
    
    override func bindViewModel(_ viewModel: Any) {
        super.bindViewModel(viewModel)
    }
    
}
