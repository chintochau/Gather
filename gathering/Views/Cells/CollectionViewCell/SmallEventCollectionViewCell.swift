//
//  EventSmallCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

final class SmallEventCollectionViewCell: BasicEventCollectionViewCell{
    static let identifier = "EventSmallCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let emojiSize:CGFloat = 35
        
        profileImageview.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 10, bottom: 0, right: 0),size: CGSize(width: emojiSize, height: emojiSize))
        profileImageview.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor,constant: 0).isActive = true
        profileImageview.layer.cornerRadius = emojiSize/2
        
        eventImageView.anchor(top: profileImageview.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: width/3.5, height: width/3.5))
        
        profileTitleLabel.anchor(top: profileImageview.topAnchor, leading: profileImageview.trailingAnchor, bottom: profileImageview.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
        
        
        titleLabel.anchor(top: profileImageview.bottomAnchor, leading: eventImageView.trailingAnchor, bottom: nil, trailing: nil,
                          padding: .init(top: 5, left: 5, bottom: 0, right: 0))
        
        dateLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: nil)
        
        locationLabel.anchor(top: dateLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: nil)
        
        
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

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PreviewHOMEVIEW: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        HomeViewController().toPreview()
    }
}
#endif

