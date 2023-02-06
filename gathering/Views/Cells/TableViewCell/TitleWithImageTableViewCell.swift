//
//  TitleWithImageTableViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-05.
//

import UIKit

class TitleWithImageTableViewCell: UITableViewCell {
    
    static let identifier = "TitleWithImageTableViewCell"
    
    let emojiButton:UIButton = {
        let view = UIButton()
        if let emoji = UserDefaults.standard.string(forKey: "selectedEmoji") {
            view.setTitle(emoji, for: .normal)
        }else {
            view.setTitle("😃", for: .normal)
        }
        view.titleLabel?.font = .systemFont(ofSize: 40)
        return view
    }()
    let titleField:UITextField = {
        let view = UITextField()
        view.placeholder = "Title"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(emojiButton)
        contentView.addSubview(titleField)
        let imageSize:CGFloat = 40
        emojiButton.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil,padding: .init(top: 5, left: 20, bottom: 5, right: 0),size: .init(width: imageSize, height: imageSize))
        
        titleField.anchor(top: emojiButton.topAnchor, leading: emojiButton.trailingAnchor, bottom: emojiButton.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
