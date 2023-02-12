//
//  EmojiEventCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-05.
//


import UIKit

final class EmojiEventCollectionViewCell: BasicEventCollectionViewCell{
    static let identifier = "EmojiEventCollectionViewCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let emojiSize:CGFloat = 35
        
        profileImageview.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
            padding: .init(top: 5, left: 10, bottom: 0, right: 0),
            size: CGSize(width: emojiSize, height: emojiSize))
        profileImageview.layer.cornerRadius = emojiSize/2
        
        profileTitleLabel.anchor(
            top: profileImageview.topAnchor, leading: profileImageview.trailingAnchor, bottom: profileImageview.bottomAnchor, trailing: nil,
            padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
        
        titleLabel.anchor(
            top: profileImageview.bottomAnchor, leading: profileImageview.leadingAnchor, bottom: nil, trailing: trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        
        dateLabel.anchor(
            top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        locationLabel.anchor(top: dateLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: nil)
        
        introLabel.anchor(top: locationLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 10, right: 10))
        
        
        // MARK: - Gender separated
        
        let imageSize:CGFloat = 25
        maleIconImageView.anchor(top: profileImageview.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,
                                 padding: .init(top: 0, left: 0, bottom: 0, right: 5),
                                 size: CGSize(width: imageSize, height: imageSize))
        
        femaleIconImageView.anchor(top: maleIconImageView.bottomAnchor, leading: maleIconImageView.leadingAnchor, bottom: nil, trailing: nil,
                                   size: CGSize(width: imageSize, height: imageSize))
        
        
        maleNumber.sizeToFit()
        maleNumber.anchor(top: maleIconImageView.topAnchor, leading: nil, bottom: maleIconImageView.bottomAnchor, trailing: maleIconImageView.leadingAnchor)
        
        femaleNumber.sizeToFit()
        femaleNumber.anchor(top: femaleIconImageView.topAnchor, leading: nil, bottom: femaleIconImageView.bottomAnchor, trailing: femaleIconImageView.leadingAnchor)
        
        // MARK: - all gender
        
        let totalImageSize:CGFloat = 30
        totalIconImageView.anchor(top: profileImageview.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,
                                  padding: .init(top: 0, left: 0, bottom: 0, right: 10),
                                  size: CGSize(width: totalImageSize, height: totalImageSize))

        totalNumber.sizeToFit()
        totalNumber.anchor(top: totalIconImageView.topAnchor, leading: nil, bottom: totalIconImageView.bottomAnchor, trailing: totalIconImageView.leadingAnchor
                           ,padding: .init(top: 0, left: 0, bottom: 0, right: 5))

//
//        
//        let buttonSize:CGFloat = 30
//        shareButton.frame = CGRect(x: width-buttonSize-5, y: priceLabel.top-buttonSize-5, width: buttonSize, height: buttonSize)
//        likeButton.frame = CGRect(x: shareButton.left-buttonSize, y: priceLabel.top-buttonSize-5, width: buttonSize, height: buttonSize)
//        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Preview1: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        HomeViewController().toPreview()
    }
}
#endif

