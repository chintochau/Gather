//
//  EmojiEventCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-05.
//


import UIKit
import IGListKit

final class PostCollectionViewCell: BasicEventCollectionViewCell,ListBindable{
    
    static let identifier = "EmojiEventCollectionViewCell"
    
    
    
    private let stackView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        // Add padding around the items
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.isLayoutMarginsRelativeArrangement = true

        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(locationLabel)
        
        [stackView].forEach({addSubview($0)})
        
        let emojiSize:CGFloat = 35
        
        profileImageview.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
            padding: .init(top: 5, left: 10, bottom: 0, right: 0),
            size: CGSize(width: emojiSize, height: emojiSize))
        
        profileImageview.layer.cornerRadius = emojiSize/2
        
        
        profileTitleLabel.anchor(
            top: profileImageview.topAnchor, leading: profileImageview.trailingAnchor, bottom: profileImageview.bottomAnchor, trailing: nil,
            padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
        
        stackView.anchor(top: profileImageview.bottomAnchor, leading: leadingAnchor, bottom: titleLabel.topAnchor, trailing: trailingAnchor)
        
        
        titleLabel.font = .systemFont(ofSize: 22)
        titleLabel.anchor(
            top: stackView.bottomAnchor, leading: profileImageview.leadingAnchor, bottom: bottomAnchor, trailing: nil,
            padding: .init(top: 0, left: 0, bottom: 20, right: 0))
        
        backgroundShade.anchor(top: profileImageview.bottomAnchor, leading: leadingAnchor, bottom: titleLabel.bottomAnchor, trailing: trailingAnchor,
                               padding: .init(top: 0, left: 0, bottom: -10, right: 0))
        
        
        
        
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
    
    func bindViewModel(_ viewModel: Any) {
        guard let vm = viewModel as? PostViewModel else { return }
        
        if let profileImage = vm.organiser?.profileUrlString {
            profileImageview.sd_setImage(with: URL(string: profileImage))
        }
        
        eventImageView.sd_setImage(with: URL(string: vm.imageUrlString ?? ""))
        dateLabel.attributedText = createAttributedText(with: vm.dateString, imageName: "calendar")
        locationLabel.attributedText = createAttributedText(with: vm.location, imageName: "mappin.and.ellipse")
        
        titleLabel.text = vm.title
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
    
    
    func createAttributedText(with text: String, imageName: String) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: "  \(text)")
        let imageAttachment = NSTextAttachment()
        let image = UIImage(systemName: imageName)?.withTintColor(.secondaryLabel)
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.replaceCharacters(in: NSRange(location: 0, length: 1), with: imageString)
        return fullString
    }
    
}


