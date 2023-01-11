//
//  EventSmallCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import SDWebImage

class EventSmallCollectionViewCell: BasicEventCollectionViewCell{
    static let identifier = "EventSmallCollectionViewCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        eventImage.frame = CGRect(x: 0, y: 0, width: contentView.height+10, height: contentView.height)
        eventImage.layer.cornerRadius = 10
        dateLabel.frame = CGRect(x: eventImage.right+5, y: 5, width: dateLabel.width, height: dateLabel.height)
        titleLabel.frame = CGRect(x: eventImage.right+5, y: dateLabel.bottom+5, width: dateLabel.width, height: dateLabel.height)
        locationLabel.frame = CGRect(x: eventImage.right+5, y: titleLabel.bottom+10, width: dateLabel.width, height: dateLabel.height)
        let buttonSize:CGFloat = 30
        shareButton.frame = CGRect(x: width-buttonSize-5, y: (height-buttonSize)/2, width: buttonSize, height: buttonSize)
        likeButton.frame = CGRect(x: shareButton.left-buttonSize, y: (height-buttonSize)/2, width: buttonSize, height: buttonSize)
    }
    
    
    override func configure(with viewModel: EventCollectionViewCellViewModel) {
        super.configure(with: viewModel)
    }
    
}
