//
//  SingleImageTableViewCell.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-08.
//

import UIKit

protocol SingleImageTableViewCellDelegate:AnyObject {
    
}

class SingleImageTableViewCell: UITableViewCell {

    static let identifier = "SingleImageTableViewCell"

    weak var delegate:SingleImageTableViewCellDelegate?
    
    private let coverImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "photo.on.rectangle.angled")
        view.tintColor = .lightGray.withAlphaComponent(0.5)
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    
    private let titleLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    
    var image:UIImage? {
        didSet {
            coverImageView.contentMode = .scaleAspectFill
            coverImageView.image = image
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(coverImageView)
        
        coverImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 10, left: 30, bottom: 0, right: 30),size: .init(width: 0, height: contentView.width))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}
