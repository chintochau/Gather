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
        
        
        let emojiSize:CGFloat = 50
        
        emojiStringView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 10, bottom: 0, right: 0),size: CGSize(width: emojiSize, height: emojiSize))
        emojiStringView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor,constant: 0).isActive = true
        
        
        dateLabel.anchor(top: emojiStringView.bottomAnchor, leading: emojiStringView.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        
        titleLabel.anchor(top: dateLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: trailingAnchor)
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor,constant: 0).isActive = true
        
        locationLabel.anchor(top: titleLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: nil)
        
        introLabel.anchor(top: locationLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: maleIconImageView.topAnchor, trailing: trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 10))
        
        
        let imageSize:CGFloat = 25
        maleIconImageView.anchor(top: nil, leading: dateLabel.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: imageSize, height: imageSize))
        maleIconImageView.topAnchor.constraint(greaterThanOrEqualTo: locationLabel.bottomAnchor,constant: 5).isActive = true
        
        femaleIconImageView.anchor(top: maleIconImageView.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: imageSize, height: imageSize))
        
        femaleIconImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5).isActive = true
        
        maleNumber.sizeToFit()
        maleNumber.anchor(top: maleIconImageView.topAnchor, leading: maleIconImageView.trailingAnchor, bottom: maleIconImageView.bottomAnchor, trailing: nil,
                          padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
        femaleNumber.sizeToFit()
        femaleNumber.anchor(top: femaleIconImageView.topAnchor, leading: femaleIconImageView.trailingAnchor, bottom: femaleIconImageView.bottomAnchor, trailing: nil,
                            padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
        
        let totalImageSize:CGFloat = 30
        totalIconImageView.anchor(top: nil, leading: dateLabel.leadingAnchor, bottom: nil, trailing: nil,size: CGSize(width: totalImageSize, height: totalImageSize))

        totalIconImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true

        totalNumber.sizeToFit()
        totalNumber.anchor(top: totalIconImageView.topAnchor, leading: totalIconImageView.trailingAnchor, bottom: totalIconImageView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 5, bottom: 0, right: 0))


        
        let buttonSize:CGFloat = 30
        shareButton.frame = CGRect(x: width-buttonSize-5, y: priceLabel.top-buttonSize-5, width: buttonSize, height: buttonSize)
        likeButton.frame = CGRect(x: shareButton.left-buttonSize, y: priceLabel.top-buttonSize-5, width: buttonSize, height: buttonSize)
        
        
        
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

