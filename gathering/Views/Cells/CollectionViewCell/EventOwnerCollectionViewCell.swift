//
//  EventOwnerCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-20.
//

import UIKit

protocol EventOwnerCollectionViewCellDelegate:AnyObject {
    func EventOwnerCollectionViewCellDidTapMessage(_ cell:EventOwnerCollectionViewCell, username:String?)
}


class EventOwnerCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventOwnerCollectionViewCell"
    
    weak var delegate:EventOwnerCollectionViewCellDelegate?
    
    private let imageView:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .secondarySystemBackground
        view.image = .personIcon
        view.layer.borderColor = UIColor.mainColor!.withAlphaComponent(0.5).cgColor
        view.tintColor = .lightGray
        view.layer.borderWidth = 1
        return view
    }()
    
    private let nameLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 22)
        return view
    }()
    
    
    private let messageButton:UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "message"), for: .normal)
        view.tintColor = .label
        return view
    }()
    
    
    
    
    var user:User? {
        didSet {
            if user?.username == UserDefaults.standard.string(forKey: "username") {
                messageButton.isHidden = true
                }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView,nameLabel,messageButton].forEach({addSubview($0)})
        let iconSize:CGFloat = 35
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: iconSize, height: iconSize))
        imageView.layer.cornerRadius = iconSize/2
        
        nameLabel.anchor(top: imageView.topAnchor, leading: imageView.trailingAnchor, bottom: bottomAnchor, trailing: messageButton.leadingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        
        messageButton.anchor(top: imageView.topAnchor, leading: nil, bottom: imageView.bottomAnchor, trailing: trailingAnchor)
        messageButton.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)
        
        
        messageButton.isHidden = !AuthManager.shared.isSignedIn
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with owner:User?) {
        
        nameLabel.text = owner?.name
        if let urlString = owner?.profileUrlString {
            imageView.sd_setImage(with: URL(string: urlString))
        }
        user = owner
        
    }
    
    @objc private func didTapFollow(){
        guard let user = user else {return}
        
    }
    
    @objc private func didTapMessage(){
        delegate?.EventOwnerCollectionViewCellDidTapMessage(self, username: user?.username)
    }
    
    
}
