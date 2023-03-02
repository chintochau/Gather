//
//  EventDetailCell.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-27.
//

import IGListKit
import UIKit

class EventDetailInfoCell : UICollectionViewCell, ListBindable {
    
    static let identifier = "EventDetailInfoCell"
    
    private let dateLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 16)
        return view
    }()
    private let timeLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 16)
        return view
    }()
    private let locationLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 16)
        return view
    }()
    private let detailTextView:UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = .robotoRegularFont(ofSize: 16)
        view.isScrollEnabled = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [dateLabel,timeLabel,locationLabel,detailTextView,separatorView].forEach({addSubview($0)})
        
        let padding:CGFloat = 30
        detailTextView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 20, left: padding, bottom: padding, right: padding))
        detailTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        let labelPadding:CGFloat = 10
        
        dateLabel.anchor(top: detailTextView.bottomAnchor, leading: detailTextView.leadingAnchor, bottom: nil, trailing: detailTextView.trailingAnchor,
                         padding: .init(top: labelPadding, left: 0, bottom: labelPadding, right: 0))
        timeLabel.anchor(top: dateLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: detailTextView.trailingAnchor,
                         padding: .init(top: labelPadding, left: 0, bottom: labelPadding, right: 0))
        locationLabel.anchor(top: timeLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: detailTextView.trailingAnchor,
                             padding: .init(top: labelPadding, left: 0, bottom: labelPadding, right: 0))
        separatorView.anchor(top: locationLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: bottomAnchor, trailing: detailTextView.trailingAnchor,
                             padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                             size: .init(width: 0, height: 3))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bindViewModel(_ viewModel: Any) {
        guard let vm = viewModel as? EventDetails else {return}
        
        dateLabel.attributedText = createAttributedText(with: vm.dateString, imageName: "calendar")
        timeLabel.attributedText = createAttributedText(with: vm.timeString, imageName: "clock")
        locationLabel.attributedText = createAttributedText(with: vm.locationString, imageName: "mappin.and.ellipse")
        detailTextView.text = vm.intro
    }
    
}



class EventDetailParticipantsCell : UICollectionViewCell, ListBindable {
    
    private let currentPartLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 16)
        return view
    }()
    
    private let genderTextLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 16)
        return view
    }()
    
    private let femaleBox:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.backgroundColor = .systemBackground
        return view
    }()
    private let maleBox:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let femaleIconView:UIImageView = {
        let view = UIImageView()
        view.image = .personIcon
        view.tintColor = .redColor
        view.contentMode  = .scaleAspectFit
        return view
    }()
    private let maleIconView:UIImageView = {
        let view = UIImageView()
        view.image = .personIcon
        view.tintColor = .blueColor
        view.contentMode  = .scaleAspectFit
        return view
    }()
    private let femaleNumber:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 20)
        return view
    }()
    private let maleNumber:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 20)
        return view
    }()
    
    
    private let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let friendText:UILabel = {
        let view = UILabel()
        return view
    }()
    
    
    
    static let identifier = "EventDetailParticipantsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [currentPartLabel,genderTextLabel,femaleBox,maleBox,separatorView,friendText].forEach({addSubview($0)})
        
        currentPartLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                                padding: .init(top: 10, left: 30, bottom: 20, right: 30))
        genderTextLabel.anchor(top: currentPartLabel.bottomAnchor, leading: currentPartLabel.leadingAnchor, bottom: nil, trailing: currentPartLabel.trailingAnchor,
                               padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        let boxWidth:CGFloat = (width-90)/2
        femaleBox.anchor(top: genderTextLabel.bottomAnchor, leading: genderTextLabel.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 10, left: 0, bottom: 20, right: 0),size: .init(width: boxWidth, height: 50))
        maleBox.anchor(top: femaleBox.topAnchor, leading: nil, bottom: nil, trailing: currentPartLabel.trailingAnchor,size: .init(width: boxWidth, height: 50))
        
        separatorView.anchor(top: femaleBox.bottomAnchor, leading: genderTextLabel.leadingAnchor, bottom: nil, trailing: maleBox.trailingAnchor,
                             padding: .init(top: 30, left: 0, bottom: 15, right: 0),size: .init(width: 0, height: 3))
        
        friendText.anchor(top: separatorView.bottomAnchor, leading: separatorView.leadingAnchor, bottom: bottomAnchor, trailing: separatorView.trailingAnchor,padding: .init(top: 15, left: 0, bottom: 20, right: 0))
        
        
        femaleBox.addSubview(femaleIconView)
        femaleBox.addSubview(femaleNumber)
        maleBox.addSubview(maleIconView)
        maleBox.addSubview(maleNumber)
        
        let iconSize:CGFloat = 40
        femaleIconView.anchor(top: femaleBox.topAnchor, leading: femaleBox.leadingAnchor, bottom: nil, trailing: nil,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 0),
                              size: .init(width: iconSize, height: iconSize))
        maleIconView.anchor(top: maleBox.topAnchor, leading: maleBox.leadingAnchor, bottom: nil, trailing: nil,
                            padding: .init(top: 5, left: 5, bottom: 0, right: 0),
                            size: .init(width: iconSize, height: iconSize))
        femaleNumber.anchor(top: femaleIconView.topAnchor, leading: femaleIconView.trailingAnchor, bottom: femaleIconView.bottomAnchor, trailing: nil,
                            padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        
        maleNumber.anchor(top: maleIconView.topAnchor, leading: maleIconView.trailingAnchor, bottom: maleIconView.bottomAnchor, trailing: nil,
                          padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        
  
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bindViewModel(_ viewModel: Any) {
        guard let vm = viewModel as? EventParticipants else {return}
        let attributedText = NSMutableAttributedString(string: "")
        let text:NSAttributedString = createAttributedText(with: "目前活動報名人數： ", imageName: "person.2.fill")
        let number:NSAttributedString = NSAttributedString(string: vm.numberOfParticipants, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        attributedText.append(text)
        attributedText.append(number)
        currentPartLabel.attributedText = attributedText
        
        genderTextLabel.text = "活動參與者性別分佈: "
        
        femaleNumber.text = vm.numberOfFemale
        maleNumber.text = vm.numberOfMale
        
        friendText.text = vm.numberOfFriends
    }
    
    
    
}
