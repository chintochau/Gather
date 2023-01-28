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
    
    let maleIconImageView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "male")?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit
        view.tintColor = .blue
        return view
    }()
    
    let femaleIconImageView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "female")?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit
        view.tintColor = .red
        return view
    }()
    
    
    let totalIconImageView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName:  "person.crop.circle")
        view.contentMode = .scaleAspectFit
        view.tintColor = .mainColor
        return view
    }()
    
    let maleNumber:UILabel = {
        let view = UILabel()
        return view
    }()
    
    let femaleNumber:UILabel = {
        let view = UILabel()
        return view
    }()
    
    let totalNumber:UILabel = {
        let view = UILabel()
        return view
    }()
    
    let priceLabel:UILabel = {
        let view = UILabel()
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            eventImageView,
            dateLabel,
            titleLabel,
            locationLabel,
            likeButton,
            shareButton,
            maleIconImageView,
            femaleIconImageView,
            maleNumber,
            femaleNumber,
            totalIconImageView,
            totalNumber,
            priceLabel
        ].forEach({addSubview($0)})
        
        
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
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
        [
            totalNumber,totalIconImageView,maleIconImageView,maleNumber,femaleNumber,femaleIconImageView
        ].forEach({$0.isHidden = false})
    }
    
    func configure(with vm:EventCollectionViewCellViewModel) {
        
        eventImageView.sd_setImage(with: URL(string: vm.imageUrlString))
        dateLabel.text = vm.date
        titleLabel.text = vm.title
        locationLabel.text = vm.location
        
        if vm.isSeparated {
            [totalNumber,totalIconImageView
            ].forEach({$0.isHidden = true})
            
            maleNumber.text = "\(vm.peopleCount.male) / \(String(vm.capacity[0]))"
            femaleNumber.text = "\(vm.peopleCount.female) / \(String(vm.capacity[1]))"
        }else {
            [maleNumber,femaleNumber,
             maleIconImageView,femaleIconImageView
            ].forEach({$0.isHidden = true})
            
            let totalNumberText = "\(vm.peopleCount.male+vm.peopleCount.female) / \(String(vm.capacity[0] + vm.capacity[1]))"
            
            totalNumber.text = totalNumberText
        }
        
        priceLabel.text = vm.price == 0.0 ? "Free" : "CA$: \(String(vm.price))"
        
    }
    
    @objc private func didTapLike (){
        print("LIKE")
    }
    
}
