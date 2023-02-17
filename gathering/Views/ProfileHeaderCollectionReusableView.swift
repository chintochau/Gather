//
//  ProfileHeaderCollectionReusableView.swift
//  Pods
//
//  Created by Jason Chau on 2023-02-08.
//

import UIKit

protocol ProfileHeaderReusableViewDelegate:AnyObject {
    func ProfileHeaderReusableViewDelegatedidTapMessage(_ header:UICollectionReusableView, user:User)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate:ProfileHeaderReusableViewDelegate?
    
    let segmentedControl: UISegmentedControl = {
        let segmentedItems = [
            "Upcoming events",
            "Past events"
        ]
        let view = UISegmentedControl(items: segmentedItems)
        view.selectedSegmentIndex = 0
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    let nameLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20)
        view.textColor = .label
        view.textAlignment = .center
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = .personIcon
        iv.tintColor = .lightGray
        iv.backgroundColor = .systemBackground
        return iv
    }()
    
    private let followButton:UIButton = {
        let view = UIButton()
        view.setTitle("Follow", for: .normal)
        view.setTitleColor(.link, for: .normal)
        return view
    }()
    
    private let messageButton:UIButton = {
        let view = UIButton()
        view.setTitle("Message", for: .normal)
        view.setTitleColor(.link, for: .normal)
        return view
    }()
    
    var isFollowing:Bool = false {
        didSet{
            if isFollowing {
                followButton.setTitle("Followed", for: .normal)
            }else {
                followButton.setTitle("Follow", for: .normal)
                
            }
        }
    }
    
    
    var user:User? {
        didSet {
            usernameLabel.text = user?.username
            nameLabel.text = user?.name
            isFollowing = DefaultsManager.shared.isUserFavourited(userID: user!.username)
            if let profileUrlString = user?.profileUrlString {
                profileImageView.sd_setImage(with: URL(string: profileUrlString))
            }
            
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [
            nameLabel,
            usernameLabel,
            profileImageView,
            segmentedControl,
            followButton,
            messageButton
        ].forEach({addSubview($0)})
        
        let imageSize:CGFloat = 80
        
        profileImageView.anchor(
            top: topAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 40, left: 0, bottom: 0, right: 0),
            size: CGSize(width: imageSize, height: imageSize))
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = imageSize/2
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        usernameLabel.anchor(
            top: nameLabel.bottomAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil)
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        followButton.anchor(top: usernameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil,size: CGSize(width: 0, height: 20))
        followButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        messageButton.anchor(top: followButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil,size: CGSize(width: 0, height: 20))
        messageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageButton.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)
        
        segmentedControl.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 20, bottom: 10, right: 20))
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func didTapFollow(){
        isFollowing.toggle()
        if isFollowing {
            DefaultsManager.shared.toFollowUser(userID: user!.username)
        }else {
            DefaultsManager.shared.removeFromFavouritedUsers(userID: user!.username)
        }
    }
    
    @objc private func didTapMessage(){
        delegate?.ProfileHeaderReusableViewDelegatedidTapMessage(self, user: user!)
    }
    
}
