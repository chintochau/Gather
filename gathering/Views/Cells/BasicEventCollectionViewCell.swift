//
//  EventSmallCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import SDWebImage

class BasicEventCollectionViewCell: UICollectionViewCell {
    
    let eventImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let likeButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName:  "heart"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let shareButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(eventImageView)
        addSubview(dateLabel)
        addSubview(titleLabel)
        addSubview(locationLabel)
        addSubview(likeButton)
        addSubview(shareButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        dateLabel.sizeToFit()
        titleLabel.sizeToFit()
        locationLabel.sizeToFit()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.image = nil
        dateLabel.text = nil
        titleLabel.text = nil
        locationLabel.text = nil
        likeButton.setImage(UIImage(systemName:  "heart"), for: .normal)
        likeButton.tintColor = .label
    }
    
    func configure(with viewModel:EventCollectionViewCellViewModel) {
        eventImageView.sd_setImage(with: URL(string: viewModel.imageUrlString))
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        locationLabel.text = viewModel.location
        
    }
    
}
