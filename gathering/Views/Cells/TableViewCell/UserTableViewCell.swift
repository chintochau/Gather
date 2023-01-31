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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [nameLabel,
        usernameLabel,
         valuelabel].forEach({$0.sizeToFit()})
        
        let imageSize = contentView.height-20
        profileImageView.frame = CGRect(x: 20, y: 10, width: imageSize, height: imageSize)
        profileImageView.layer.cornerRadius = imageSize/2
        nameLabel.frame = CGRect(x: profileImageView.right+10, y: contentView.height/2-nameLabel.height, width: nameLabel.width, height: nameLabel.height)
        usernameLabel.frame = CGRect(x:nameLabel.left , y: nameLabel.bottom, width: usernameLabel.width, height: usernameLabel.height)
        valuelabel.frame = CGRect(x: contentView.width-valuelabel.width, y: 5, width: valuelabel.width, height: valuelabel.height)
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
        
    }
    
    

}
