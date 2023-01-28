//
//  ProfileHeaderView.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-25.
//

import UIKit

struct ProfileHeaderViewViewModel {
    let profileUrlString:String?
    let username:String
    let email:String
}

class ProfileHeaderView: UIView {
    
    private let imageView:UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: "person.crop.circle")
        view.tintColor = .lightGray
        view.backgroundColor = .secondarySystemBackground
        return view
        
    }()
    
    private let usernameLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 30,weight: .bold)
        return view
        
    }()
    private let emailLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [
            imageView,
            emailLabel,
            usernameLabel
        ].forEach({addSubview($0)})
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = width/4
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        imageView.layer.cornerRadius = imageSize/2
        usernameLabel.frame = CGRect(x: 40, y: imageView.bottom+10, width: width-80, height: 30)
        emailLabel.frame = CGRect(x: 40, y: usernameLabel.bottom, width: width-80, height: 30)
    }
    
    func configure(with vm:ProfileHeaderViewViewModel) {
        if let urlString = vm.profileUrlString{
        imageView.sd_setImage(with: URL(string: urlString))}
        
        usernameLabel.text = vm.username
        emailLabel.text = vm.email
    }
    
}
