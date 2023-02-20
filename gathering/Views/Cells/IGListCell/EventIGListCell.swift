//
//  EventIGListCell.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import UIKit
import IGListKit



class EventCell: BasicEventCollectionViewCell, ListBindable {
    
    static let identifier = "EventCellIdentifier"
    
    private let nameLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let emojiSize:CGFloat = 35
        
        profileImageview.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
            padding: .init(top: 5, left: 10, bottom: 0, right: 0),
            size: CGSize(width: emojiSize, height: emojiSize))
        profileImageview.layer.cornerRadius = emojiSize/2
        
        profileTitleLabel.anchor(
            top: profileImageview.topAnchor, leading: profileImageview.trailingAnchor, bottom: profileImageview.bottomAnchor, trailing: nil,
            padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
        
        titleLabel.anchor(
            top: profileImageview.bottomAnchor, leading: profileImageview.leadingAnchor, bottom: nil, trailing: trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        
        dateLabel.anchor(
            top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        locationLabel.anchor(top: dateLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: nil)
        
        introLabel.anchor(top: locationLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 10, right: 10))
        
        
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
        
        
        backgroundShade.anchor(top: titleLabel.topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    func bindViewModel(_ viewModel: Any) {
        guard let vm = viewModel as? EventHomeCellViewModel else { return }
        // Update the cell with the event information
        if let profileImage = vm.organiser.profileUrlString {
            profileImageview.sd_setImage(with: URL(string: profileImage))
        }
        eventImageView.sd_setImage(with: URL(string: vm.imageUrlString ?? ""))
        dateLabel.text = vm.dateString + " - " + vm.dayString + "\n" + vm.timeString
        titleLabel.text = vm.title
        locationLabel.text = vm.location
        emojiStringView.text = vm.emojiString
        introLabel.text = vm.intro
        profileTitleLabel.text = vm.organiser.name
        
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
    
    
    
}




class PeopleCell: UICollectionViewCell, ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let event = viewModel as? EventHomeCellViewModel else { return }
        // Update the cell with the event information
    }
}

class PlaceCell: UICollectionViewCell, ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let event = viewModel as? EventHomeCellViewModel else { return }
        // Update the cell with the event information
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PreviewHOME: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        HomeViewController().toPreview()
    }
}
#endif

