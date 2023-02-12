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

