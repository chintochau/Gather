//
//  EventOwnerCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-20.
//

import UIKit



class EventOwnerCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventOwnerCollectionViewCell"
    
    private let imageView:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .secondarySystemBackground
        view.image = UIImage(systemName: "person.crop.circle")
        view.layer.borderColor = UIColor.mainColor!.withAlphaComponent(0.5).cgColor
        view.tintColor = .lightGray
        view.layer.borderWidth = 1
        return view
    }()
    
    private let nameLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 25)
        return view
    }()
    private let descriptionLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18,weight: .light)
        view.textColor = .lightGray
        view.text = "Description..."
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView,nameLabel,descriptionLabel].forEach({addSubview($0)})
        let iconSize:CGFloat = 60
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: iconSize, height: iconSize))
        imageView.layer.cornerRadius = iconSize/2
        nameLabel.anchor(top: imageView.topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        descriptionLabel.anchor(top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with owner:String) {
        nameLabel.text = owner
    }
    
    
}
