//
//  EventSmallCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import SDWebImage

class BasicEventCollectionViewCell: UICollectionViewCell {
    static let titleTextSize:CGFloat = 20
    static let subTextSize:CGFloat = 12
    static let introTextSize:CGFloat = 0
    static let iconSize:CGFloat = 20
    static let generalIconSize:CGFloat = 40
    
    let profileImageview:UIImageView = {
        let view = UIImageView()
        view.image = .personIcon
        view.tintColor = .lightGray
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileTitleLabel:UILabel = {
        let label = UILabel()
//        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    let eventImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let emojiIconLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: generalIconSize)
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: titleTextSize,weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let introLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.lineBreakMode = .byTruncatingTail
        view.font = .preferredFont(forTextStyle: .body)
        return view
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: subTextSize)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    let locationLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: subTextSize)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    let headCountLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: subTextSize)
        view.numberOfLines = 2
        view.textColor = .secondaryLabel
        view.textAlignment = .right
        return view
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
    
    
     let backgroundShade:UIView = {
        let view = UIView()
        view.backgroundColor = .streamWhiteSnow
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            backgroundShade,
            profileImageview,
            eventImageView,
            titleLabel,
            likeButton,
            shareButton,
            maleIconImageView,
            femaleIconImageView,
            maleNumber,
            femaleNumber,
            totalIconImageView,
            totalNumber,
            priceLabel,
            emojiIconLabel,
            introLabel,
            profileTitleLabel
        ].forEach({addSubview($0)})
        
        
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.sizeToFit()
        titleLabel.sizeToFit()
        locationLabel.sizeToFit()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageview.image = .personIcon
        eventImageView.image = nil
        dateLabel.text = nil
        titleLabel.text = nil
        locationLabel.text = nil
        likeButton.setImage(UIImage(systemName:  "heart"), for: .normal)
        likeButton.tintColor = .label
        emojiIconLabel.text = nil
        introLabel.text = nil
        profileTitleLabel.text = nil
        
        [
            totalNumber,totalIconImageView,maleIconImageView,maleNumber,femaleNumber,femaleIconImageView
        ].forEach({$0.isHidden = false})
    }
    
    func configure(with vm:EventHomeCellViewModel) {
        if let profileImage = vm.organiser?.profileUrlString {
            profileImageview.sd_setImage(with: URL(string: profileImage))
        }
        eventImageView.sd_setImage(with: URL(string: vm.imageUrlString ?? ""))
        titleLabel.text = vm.title
        locationLabel.text = vm.location
        emojiIconLabel.text = vm.emojiString
        introLabel.text = vm.intro
        profileTitleLabel.text = vm.organiser?.name

        if vm.headcount.isGenderSpecific {
            [totalNumber,totalIconImageView
            ].forEach({$0.isHidden = true})
            
            let maleMax = vm.headcount.mMax
            let femaleMax = vm.headcount.fMax
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
            
            
        }else {
            [maleNumber,femaleNumber,
             maleIconImageView,femaleIconImageView
            ].forEach({$0.isHidden = true})
            totalNumber.text = vm.totalString
        }
        
        priceLabel.text = vm.price
        
    }
    
    @objc private func didTapLike (){
        print("LIKE")
    }
    
}
