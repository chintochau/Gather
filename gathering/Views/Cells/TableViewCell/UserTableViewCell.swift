//
//  UserTableViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-30.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    private let profileImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.image = UIImage(systemName: "person.crop.circle")
        view.tintColor = .lightGray
        return view
    }()
    
    private let nameLabel:UILabel = {
        let view  = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 20)
        return view
    }()
    private let usernameLabel:UILabel = {
        let view  = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 1
        return view
    }()
    private let valuelabel:UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.numberOfLines = 1
        return view
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            profileImageView,
            nameLabel,
            usernameLabel,
            valuelabel
        ].forEach({contentView.addSubview($0)})
        
        let imageSize:CGFloat = 50
        profileImageView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: nil,
            padding: .init(top: 5, left: 20, bottom: 5, right: 0),
            size: CGSize(width: imageSize, height: imageSize))
        profileImageView.layer.cornerRadius = imageSize/2
        
        nameLabel.anchor(top: nil, leading: profileImageView.trailingAnchor, bottom: contentView.centerYAnchor, trailing: nil,padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        usernameLabel.anchor(top: contentView.centerYAnchor, leading: nameLabel.leadingAnchor, bottom: nil, trailing: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [nameLabel,
        usernameLabel,
         valuelabel].forEach({$0.text = nil})
        profileImageView.image = nil
    }
    
    func configure(with vm:User,value:String = ""){
        nameLabel.text = vm.name
        usernameLabel.text = "@\(vm.username)"
        profileImageView.sd_setImage(with: URL(string: vm.profileUrlString ?? ""))
        valuelabel.text = value
    }
    
    func configure(with vm:Participant){
        nameLabel.text = vm.name
        if let urlString = vm.profileUrlString {
            profileImageView.sd_setImage(with: URL(string: urlString))
        }else {
            profileImageView.image =  UIImage(systemName: "person.circle")
        }
        if let username = vm.username {
            usernameLabel.text = "@\(username)"
        }else {
            usernameLabel.text = "Guest"
        }
    }
    
    

}
