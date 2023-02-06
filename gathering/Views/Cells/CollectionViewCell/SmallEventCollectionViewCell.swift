//
//  EventSmallCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

final class SmallEventCollectionViewCell: BasicEventCollectionViewCell{
    static let identifier = "EventSmallCollectionViewCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .secondarySystemBackground
        
        
        eventImageView.frame = CGRect(x: 0, y: 0, width: height, height: height)
        eventImageView.layer.cornerRadius = 10
        
        dateLabel.frame = CGRect(x: eventImageView.right+5, y: 5, width: dateLabel.width, height: dateLabel.height)
        titleLabel.frame = CGRect(x: eventImageView.right+5, y: dateLabel.bottom+5, width: titleLabel.width, height: dateLabel.height)
        locationLabel.frame = CGRect(x: eventImageView.right+5, y: titleLabel.bottom+10, width: locationLabel.width, height: dateLabel.height)
        
        
        
        priceLabel.sizeToFit()
        priceLabel.frame = CGRect(x: width-priceLabel.width-10, y: height-priceLabel.height-10, width: priceLabel.width, height: priceLabel.height)
        
        
        let buttonSize:CGFloat = 30
        shareButton.frame = CGRect(x: width-buttonSize-5, y: priceLabel.top-buttonSize-5, width: buttonSize, height: buttonSize)
        likeButton.frame = CGRect(x: shareButton.left-buttonSize, y: priceLabel.top-buttonSize-5, width: buttonSize, height: buttonSize)
        
        
        let imageSize:CGFloat = 22
        
        maleIconImageView.frame = CGRect(x: eventImageView.right+5, y: height-2*buttonSize+5, width: imageSize, height: imageSize)
        femaleIconImageView.frame = CGRect(x: eventImageView.right+5, y: height-buttonSize, width: imageSize, height: imageSize)
        maleNumber.sizeToFit()
        
        maleNumber.frame = CGRect(x: maleIconImageView.right+5, y: maleIconImageView.bottom-maleNumber.height, width: maleNumber.width, height: maleNumber.height)
        femaleNumber.sizeToFit()
        femaleNumber.frame = CGRect(x: femaleIconImageView.right+5, y: femaleIconImageView.bottom-femaleNumber.height, width: femaleNumber.width, height: femaleNumber.height)
        
        
        
        let totalImageSize:CGFloat = 30
        totalIconImageView.frame = CGRect(x: eventImageView.right+5, y: height-buttonSize, width: totalImageSize, height: totalImageSize)
        totalNumber.sizeToFit()
        totalNumber.frame = CGRect(
            x: totalIconImageView.right+5, y: totalIconImageView.top, width: totalNumber.width, height:totalImageSize)
        
    }
    
}
