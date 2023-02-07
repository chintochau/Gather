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
    
    let emojiStringView:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 30)
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let introLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 4
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let locationLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
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
        view.image = UIImage(systemName:  "person.crop.circle")
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(named: "blueColor")
        return view
    }()
    
    let femaleIconImageView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName:  "person.crop.circle")
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(named: "redColor")
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
            priceLabel,
            emojiStringView,
            introLabel
        ].forEach({addSubview($0)})
        
        
        layer.borderColor = UIColor.opaqueSeparator.cgColor
        layer.borderWidth = 0.5
        
        
        
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
        emojiStringView.text = nil
        introLabel.text = nil
        [
            totalNumber,totalIconImageView,maleIconImageView,maleNumber,femaleNumber,femaleIconImageView
        ].forEach({$0.isHidden = false})
    }
    
    func configure(with vm:EventCollectionViewCellViewModel) {
        
        eventImageView.sd_setImage(with: URL(string: vm.imageUrlString ?? ""))
        dateLabel.text = vm.dateString + " - " + vm.dayString + "\n" + vm.timeString
        titleLabel.text = vm.title
        locationLabel.text = vm.location
        emojiStringView.text = vm.emojiString
        introLabel.text = vm.intro

        if vm.isSeparated {
            [totalNumber,totalIconImageView
            ].forEach({$0.isHidden = true})
            
            if let maleMax = vm.headcount.mMax,let femaleMax = vm.headcount.fMax{
                if maleMax == 0 {
                    maleNumber.text = "\(vm.peopleCount.male)"
                }else {
                    maleNumber.text = "\(vm.peopleCount.male) / \(maleMax)"
                }
                if femaleMax == 0 {
                    femaleNumber.text = "\(vm.peopleCount.female)"
                }else {
                    femaleNumber.text = "\(vm.peopleCount.female) / \(femaleMax)"
                }
            }
            
        }else {
            [maleNumber,femaleNumber,
             maleIconImageView,femaleIconImageView
            ].forEach({$0.isHidden = true})
            
            var totalNumberText = ""
            if vm.totalCapacity == 0 {
                totalNumberText = "\(vm.peopleCount.male+vm.peopleCount.female)"
            }else {
                totalNumberText = "\(vm.peopleCount.male+vm.peopleCount.female) / \(vm.totalCapacity)"
            }
            
            
            totalNumber.text = totalNumberText
        }
        
        priceLabel.text = vm.price == 0.0 ? "Free" : "CA$: \(String(vm.price))"
        
    }
    
    @objc private func didTapLike (){
        print("LIKE")
    }
    
}
