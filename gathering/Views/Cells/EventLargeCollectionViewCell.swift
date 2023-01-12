//
//  EventLargeCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

final class EventLargeCollectionViewCell: BasicEventCollectionViewCell {
    static let identifier = "EventLargeCollectionViewCell"
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .secondarySystemBackground
        eventImage.frame = CGRect(x: 0, y: 0, width: width, height: (height)/1.7)
        dateLabel.frame = CGRect(x: 7, y: eventImage.bottom+10, width: dateLabel.width, height: dateLabel.height)
        titleLabel.frame = CGRect(x: 7, y: dateLabel.bottom+5, width: titleLabel.width, height: titleLabel.height)
        locationLabel.frame = CGRect(x: 7, y: titleLabel.bottom+10, width: locationLabel.width, height: locationLabel.height)
        let buttonSize:CGFloat = 30
        shareButton.frame = CGRect(x: width-buttonSize-5, y: height-buttonSize-5, width: buttonSize, height: buttonSize)
        likeButton.frame = CGRect(x: shareButton.left-buttonSize, y: height-buttonSize-5, width: buttonSize, height: buttonSize)
    }
    
    
}
